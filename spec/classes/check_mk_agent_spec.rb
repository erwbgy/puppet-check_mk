require 'spec_helper'
describe 'check_mk::agent', :type => :class do
  context 'Redhat Linux' do
    let :facts do
      {
          :kernel          => 'Linux',
          :operatingsystem => 'Redhat',
          :osfamily        => 'Redhat',
      }
    end
    context 'with defaults for all parameters' do
      it { should contain_class('check_mk::agent') }
      it { should contain_class('check_mk::agent::install').that_comes_before('Class[check_mk::agent::config]') }
      it { should contain_class('check_mk::agent::config') }
      it { should contain_class('check_mk::agent::service') }
    end
    context 'with mrpe_checks' do
      context 'not a hash' do
        let :params do
          {
              :mrpe_checks => 'not_a_hash',
          }
        end
        it 'should fail' do
          expect { catalogue }.to raise_error(Puppet::Error, /\"not_a_hash\" is not a Hash./)
        end
      end
      context 'defined correctly' do
        let :params do
          {
              :mrpe_checks => {
                  'check1' => {'command' => 'command1'},
                  'check2' => {'command' => 'command2'},
              }
          }
        end
        it { should contain_class('check_mk::agent') }
        it { should contain_check_mk__agent__mrpe('check1').with_command('command1') }
        it { should contain_check_mk__agent__mrpe('check2').with_command('command2') }
      end
    end
  end
end
