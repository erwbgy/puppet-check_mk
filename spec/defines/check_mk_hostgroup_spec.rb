require 'spec_helper'
describe 'check_mk::hostgroup', :type => :define do

  context 'with hostgroups, host_tags and description' do
    let :title do
      'TEST_HOSTGROUP'
    end
    hostgroups = {
        'TEST_HOSTGROUP' => {
            'host_tags' => [
                'tag1',
                'tag2',
            ],
            'description' => 'TEST_DESCRIPTION',
        },
    }
    let :params do
      {
          :dir        => '/dir',
          :hostgroups => hostgroups,
          :target     => 'target'
      }
    end
    it { should contain_check_mk__hostgroup('TEST_HOSTGROUP') }
    it { should contain_concat__fragment('check_mk-hostgroup-TEST_HOSTGROUP').with({
          :target  => 'target',
          :content => /^  \( 'TEST_HOSTGROUP', \[ 'tag1', 'tag2' \], ALL_HOSTS \),\n$/,
          :order   => 21,
      })
    }
    expected_file_content = <<EOS
define hostgroup {
  hostgroup_name TEST_HOSTGROUP
  alias TEST_DESCRIPTION
}
EOS
    it { should contain_file('/dir/TEST_HOSTGROUP.cfg').with({
           :ensure => 'present',
           :content => expected_file_content,
       })
    }
  end

  context 'with hostgroups without description' do
    let :title do
      'TEST_HOUSTGROUP_WITH_UNDERSCORES'
    end
    hostgroups = {
        'TEST_HOUSTGROUP_WITH_UNDERSCORES' => {
            'host_tags' => [
                'tag1',
                'tag2',
            ],
        },
    }
    let :params do
      {
          :dir        => '/dir',
          :hostgroups => hostgroups,
          :target     => '/target'
      }
    end
    it { should contain_check_mk__hostgroup('TEST_HOUSTGROUP_WITH_UNDERSCORES') }
    it { should contain_concat__fragment('check_mk-hostgroup-TEST_HOUSTGROUP_WITH_UNDERSCORES').with({
          :target  => '/target',
          :content => /^  \( 'TEST_HOUSTGROUP_WITH_UNDERSCORES', \[ 'tag1', 'tag2' \], ALL_HOSTS \),\n$/,
          :order   => 21,
      })
    }
    expected_file_content = <<EOS
define hostgroup {
  hostgroup_name TEST_HOUSTGROUP_WITH_UNDERSCORES
  alias TEST HOUSTGROUP_WITH_UNDERSCORES
}
EOS
    it { should contain_file('/dir/TEST_HOUSTGROUP_WITH_UNDERSCORES.cfg').with({
            :ensure  => 'present',
            :content => expected_file_content,
        })
    }
  end

end
