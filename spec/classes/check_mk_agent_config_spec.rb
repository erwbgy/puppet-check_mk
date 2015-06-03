require 'spec_helper'
describe 'check_mk::agent::config', :type => :class do

  context 'Redhat Linux' do
    let :facts do
      {
          :kernel   => 'Linux',
          :osfamily => 'RedHat',
      }
    end
    context 'with defaults for all parameters' do
      it { should contain_class('check_mk::agent::config') }
      it { should contain_file('/etc/xinetd.d/check-mk-agent').
                      with_content(/^\tport\s+ = $/).
                      with_content(/^\tuser\s+ = $/).
                      with_content(/^\tserver\s+ = \/check_mk_agent$/).
                      without_content(/only_from/)
      }
      it { should contain_file('/etc/xinetd.d/check_mk').with_ensure('absent') }
    end
  end
end


