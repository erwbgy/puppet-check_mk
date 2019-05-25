require 'spec_helper'
describe 'check_mk', :type => :class do

  context 'with defaults for all parameters' do
    it { should contain_class('check_mk') }
    it { should contain_class('check_mk::install').with({
          :filestore => nil,
          :package   => 'omd-0.56',
          :site      => 'monitoring',
          :workspace => '/root/check_mk',
      }).that_comes_before('Class[check_mk::config]') }
    it { should contain_class('check_mk::config').with({
          :host_groups => nil,
          :site        => 'monitoring',
       }).that_comes_before('Class[check_mk::service]') }
    it { should contain_class('check_mk::service') }
  end
end
