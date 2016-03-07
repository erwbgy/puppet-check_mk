require 'spec_helper'
describe 'check_mk::agent', :type => :class do
  context 'Redhat Linux' do
    let :facts do
      {
          :kernel => 'Linux',
          :operatingsystem => 'Redhat',
          :osfamily => 'Redhat',
      }
    end
    context 'with defaults for all parameters' do
      it { should contain_class('check_mk::agent') }
      it { should contain_class('check_mk::agent::install').that_comes_before('Class[check_mk::agent::config]') }
      it { should contain_class('check_mk::agent::config') }
      it { should contain_class('check_mk::agent::service') }
    end
  end
end
