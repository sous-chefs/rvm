require 'spec_helper'

describe 'rvm_system_install' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['rvm_system_install']) do |node|
      node.automatic['platform_family'] = 'debian'
    end.converge('test::system_install')
  end

  before do
    # Stub gpg cookbook resources
    allow_any_instance_of(Chef::Recipe).to receive(:gpg_install).and_return(true)
    allow_any_instance_of(Chef::Recipe).to receive(:gpg_key).and_return(true)

    # Stub RVM helper methods
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_installed?).and_return(false)

    # Stub execute resources
    stub_command('bash -c "source /etc/profile.d/rvm.sh && rvm --version"').and_return(true)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'creates rvm group' do
    expect(chef_run).to create_group('rvm')
  end
end
