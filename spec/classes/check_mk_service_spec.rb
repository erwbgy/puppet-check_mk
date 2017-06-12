require 'spec_helper'
describe 'check_mk::service', :type => :class do
  context 'with defaults for all parameters' do
    it { should contain_class('check_mk::service') }
    it { should contain_service('httpd').with({
          :ensure => 'running',
          :enable => 'true',
      })
    }
    it { should contain_service('omd').with({
          :ensure => 'running',
          :enable => 'true',
      })
    }
  end
end
