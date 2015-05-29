require 'spec_helper'
describe 'check_mk::agent::install', :type => :class do

  context 'RedHat Linux' do
    let :facts do
      {
          :kernel => 'Linux',
          :operatingsystem => 'Redhat',
          :osfamily => 'Redhat',
      }
    end
    context 'with necessary parameters set' do
      let :params do
        {
            :version => '1.2.3',
            :filestore => false,
            :workspace => '/workspace',
            :package => 'custom-package',
        }
      end
      it { should contain_class('check_mk::agent::install') }
      it { should contain_package('xinetd') }
      it { should contain_package('check_mk-agent').with_name('custom-package') }
    end

    context 'with filestore' do
      let :params do
        {
            :version   => '1.2.3',
            :filestore => '/filestore',
            :workspace => '/workspace',
            :package   => 'custom-package',
        }
      end
      it { should contain_class('check_mk::agent::install') }
      it { should contain_package('xinetd') }
      it { should contain_file('/workspace').with_ensure('directory') }
      it { should contain_File('/workspace/check_mk-agent-1.2.3.noarch.rpm').with({
            :ensure  => 'present',
            :source  => '/filestore/check_mk-agent-1.2.3.noarch.rpm',
            :require => 'Package[xinetd]',
        }).that_comes_before('Package[check_mk-agent]')
      }
      it { should contain_package('check_mk-agent').with({
            :provider => 'rpm',
            :source   => '/workspace/check_mk-agent-1.2.3.noarch.rpm',
        })
      }
    end
  end

end
