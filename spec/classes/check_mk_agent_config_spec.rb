require 'spec_helper'
describe 'check_mk::agent::config', :type => :class do

  context 'Redhat Linux' do
    let :facts do
      {
          :osfamily => 'RedHat',
      }
    end
    context 'with defaults for all parameters' do
      it { should contain_class('check_mk::agent::config') }
      it { should contain_file('/etc/xinetd.d/check-mk-agent').
          with_content(/^\tport\s+ = 6556$/).
          with_content(/^\tuser\s+ = root$/).
          with_content(/^\tserver\s+ = \/usr\/bin\/check_mk_agent$/).
          without_content(/only_from/).
          with_notify('Class[Check_mk::Agent::Service]')
      }
      it { should contain_file('/etc/xinetd.d/check_mk').with_ensure('absent') }
    end
    context 'with use_cache' do
      let :params do
        {
            :use_cache => true,
        }
      end
      it { should contain_file('/etc/xinetd.d/check-mk-agent').
          with_content(/^\tserver\s+ = \/usr\/bin\/check_mk_caching_agent$/)
      }
    end
    context 'with ip_whitelist' do
      let :params do
        {
            :ip_whitelist => [
                '1.2.3.4',
                '5.6.7.8',
            ],
        }
      end
      it { should contain_file('/etc/xinetd.d/check-mk-agent').
          with_content(/^\tonly_from\s+= 127.0.0.1 1.2.3.4 5.6.7.8$/)
      }
    end
    context 'with custom user' do
      let :params do
        {
            :user => 'custom',
        }
      end
      it { should contain_file('/etc/xinetd.d/check-mk-agent').
          with_content(/^\tuser\s+ = custom$/)
      }
    end
  end

  context 'Other OS' do
    context 'with defaults for all parameters' do
      it { should contain_file('/etc/xinetd.d/check_mk').
          with_content(/^\tport\s+ = 6556$/).
          with_content(/^\tuser\s+ = root$/).
          with_content(/^\tserver\s+ = \/usr\/bin\/check_mk_agent$/).
          without_content(/only_from/).
          with_notify('Class[Check_mk::Agent::Service]')
      }
      it { should_not contain_file('/etc/xinetd.d/check_mk').with_ensure('absent') }
    end
  end
end


