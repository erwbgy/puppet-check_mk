require 'spec_helper'
describe 'check_mk::install_tarball', :type => :class do
  context 'with necessary parameters set' do
    let :params do
      {
          :filestore => '/filestore',
          :version   => '1.2.3',
          :workspace => '/workspace',
      }
    end
    it { should contain_class('check_mk::install_tarball') }
    it { should contain_package('nagios').with_ensure('present').that_comes_before('Package[nagios-plugins-all]') }
    installed_packages = [
        'xinetd',
        'mod_python',
        'make',
        'gcc-c++',
        'tar',
        'gzip'
    ]
    installed_packages.each do |package|
      it { should contain_package(package).with_ensure('present') }
    end
    it { should contain_file('/etc/nagios/passwd').with({
          :ensure => 'present',
          :owner  => 'root',
          :group  => 'apache',
          :mode   => '0640',
      })
    }
    it { should contain_exec('set-nagiosadmin-password').with({
          :refreshonly => true,
          :require     => 'File[/etc/nagios/passwd]',
      })
    }
    it { should contain_exec('set-guest-password').with({
          :refreshonly => true,
          :require     => 'File[/etc/nagios/passwd]',
      })
    }
    it { should contain_exec('add-apache-to-nagios-group').with({
          :refreshonly => true,
      })
    }
    it { should contain_package('nagios-plugins-all').with({
          :ensure  => 'present',
          :require => 'Package[nagios]',
      })
    }
    it { should contain_exec('unpack-check_mk-tarball').with({
          :command => '/bin/tar -zxf /workspace/check_mk-1.2.3.tar.gz',
          :cwd     => '/workspace',
          :creates => '/workspace/check_mk-1.2.3',
          :require => 'File[/workspace/check_mk-1.2.3.tar.gz]',
      })
    }
    it { should contain_exec('change-setup-config-location').with({
          :command => "/usr/bin/perl -pi -e 's#^SETUPCONF=.*?$#SETUPCONF=/workspace/check_mk_setup.conf#' /workspace/check_mk-1.2.3/setup.sh",
          :unless  => "/bin/egrep '^SETUPCONF=/workspace/check_mk_setup.conf$' /workspace/check_mk-1.2.3/setup.sh",
          :require => 'Exec[unpack-check_mk-tarball]',
      })
    }
    it { should contain_exec('remove-setup-header').with({
          :command => "/usr/bin/perl -pi -e 's#^DIRINFO=.*?$#DIRINFO=#' /workspace/check_mk-1.2.3/setup.sh",
          :unless  => "/bin/egrep '^DIRINFO=$' /workspace/check_mk-1.2.3/setup.sh",
          :require => 'Exec[unpack-check_mk-tarball]',
      })
    }
    it { should contain_file('/workspace/check_mk_setup.conf').that_notifies('Exec[check_mk-setup]') }
    it { should contain_file('/etc/nagios/check_mk').with({
          :ensure  => 'directory',
          :owner   => 'nagios',
          :group   => 'nagios',
          :recurse => true,
          :require => 'Package[nagios]',
      })
    }
    it { should contain_file('/etc/nagios/check_mk/hostgroups').with({
          :ensure  => 'directory',
          :owner   => 'nagios',
          :group   => 'nagios',
          :require => 'File[/etc/nagios/check_mk]',
      })
    }
    it { should contain_exec('check_mk-setup').with({
           :command     => '/workspace/check_mk-1.2.3/setup.sh --yes',
           :cwd         => '/workspace/check_mk-1.2.3',
           :refreshonly => true,
           :require => [
               'Exec[change-setup-config-location]',
               'Exec[remove-setup-header]',
               'Exec[unpack-check_mk-tarball]',
               'File[/workspace/check_mk_setup.conf]',
               'File[/etc/nagios/check_mk]',
               'Package[nagios]',
           ],
           :notify      => 'Class[Check_mk::Service]',
       })
    }

  end
end
