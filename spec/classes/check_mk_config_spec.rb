require 'spec_helper'
describe 'check_mk::config', :type => :class do
  context 'with site set' do
    let :params do
      {
          :site => 'TEST_SITE'
      }
    end
    it { should contain_class('check_mk::config') }
    it { should contain_file('/omd/sites/TEST_SITE/etc/nagios/local').with_ensure_directory.
                    that_comes_before('File_line[nagios-add-check_mk-cfg_dir]')
    }
    it { should contain_file_line('nagios-add-check_mk-cfg_dir').with({
          :ensure => 'present',
          :line   => 'cfg_dir=/omd/sites/TEST_SITE/etc/nagios/local',
          :path   => '/omd/sites/TEST_SITE/etc/nagios/nagios.cfg',
          :notify => 'Class[Check_mk::Service]',
      })
    }
    it { should contain_file_line('add-guest-users').with({
          :ensure => 'present',
          :line   => 'guest_users = [ "guest" ]',
          :path   => '/omd/sites/TEST_SITE/etc/check_mk/multisite.mk',
      })
    }
    it { should contain_file('/omd/sites/TEST_SITE/etc/check_mk/all_hosts_static').with({
          :ensure  => 'file',
          :content => '',
      })
    }
    it { should contain_concat('/omd/sites/TEST_SITE/etc/check_mk/main.mk').with({
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0644',
          :notify => 'Exec[check_mk-refresh]',
      })
    }
    it { should contain_concat__fragment('all_hosts-header').with({
          :target  => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          :content => /all_hosts = \[\n/,
          :order  => 10,
      })
    }
    it { should contain_concat__fragment('all_hosts-footer').with({
          :target => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          :content => /\]\n/,
          :order  => 19,
      })
    }
    it { should contain_concat__fragment('all-hosts-static').with({
          :ensure => '/omd/sites/TEST_SITE/etc/check_mk/all_hosts_static',
          :target => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          :order  => 18,
      })
    }
    it { should_not contain_file('/omd/sites/TEST_SITE/etc/nagios/local/hostgroups') }
    it { should_not contain_concat__fragment('host_groups-header') }
    it { should_not contain_concat__fragment('host_groups-footer') }
    it { should_not contain_check_mk__hostgroup }
    it { should contain_concat__fragment('check_mk-local-config').with({
          :ensure => '/omd/sites/TEST_SITE/etc/check_mk/main.mk.local',
          :target => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          :order  => 99,
      })
    }
    it { should contain_exec('check_mk-refresh').with({
          :command     => /\/bin\/su -l -c '\/omd\/sites\/TEST_SITE\/bin\/check_mk -I' TEST_SITE/,
          :refreshonly => true,
      })
    }
    it { should contain_exec('check_mk-reload').with({
          :command     => /\/bin\/su -l -c '\/omd\/sites\/TEST_SITE\/bin\/check_mk -O' TEST_SITE/,
          :refreshonly => true,
      })
    }
    it { should contain_cron('check_mk-refresh-inventory-daily').with({
          :user    => 'root',
          :command => /su -l -c '\/omd\/sites\/TEST_SITE\/bin\/check_mk -O' TEST_SITE/,
          :minute  => 0,
          :hour    => 0,
      })
    }
  end
  context 'with host_groups' do
    host_groups = {
        'group1' => {'host_tags' => []},
        'group2' => {'host_tags' => []},
    }
    let :params do
      {
          :site => 'TEST_SITE',
          :host_groups => host_groups,
      }
    end
    it { should contain_class('check_mk::config') }
    it { should contain_file('/omd/sites/TEST_SITE/etc/nagios/local/hostgroups').with_ensure_directory }
    it { should contain_concat__fragment('host_groups-header').with({
          :target => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          :content => /host_groups = \[\n/,
          :order  => 20,
      })
    }
    it { should contain_concat__fragment('host_groups-footer').with({
          :target => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          :content => /\]\n/,
          :order  => 29,
      })
    }
    it { should contain_check_mk__hostgroup('group1').with({
          :dir        => '/omd/sites/TEST_SITE/etc/nagios/local/hostgroups',
          :hostgroups => host_groups,
          :target     => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          :notify     => 'Exec[check_mk-refresh]',
      })
    }
    it { should contain_check_mk__hostgroup('group2').with({
          :dir        => '/omd/sites/TEST_SITE/etc/nagios/local/hostgroups',
          :hostgroups => host_groups,
          :target     => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          :notify     => 'Exec[check_mk-refresh]',
      })
    }
  end
end
