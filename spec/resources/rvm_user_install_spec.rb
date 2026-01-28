require 'spec_helper'

describe 'rvm_user_install' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['rvm_user_install']) do |node|
      node.automatic['platform_family'] = 'debian'
    end.converge('test::user_install')
  end

  before do
    # Stub gpg cookbook resources
    allow_any_instance_of(Chef::Recipe).to receive(:gpg_install).and_return(true)
    allow_any_instance_of(Chef::Recipe).to receive(:gpg_key).and_return(true)

    # Stub RVM helper methods
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_installed?).and_return(false)
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:user_home).with('vagrant').and_return('/home/vagrant')

    # Stub Etc.getpwnam for user lookup
    user_struct = Struct.new(:name, :passwd, :uid, :gid, :gecos, :dir, :shell)
    vagrant_user = user_struct.new('vagrant', 'x', 1000, 1000, 'Vagrant', '/home/vagrant', '/bin/bash')
    allow(Etc).to receive(:getpwnam).with('vagrant').and_return(vagrant_user)

    # Stub execute resources
    stub_command('bash -c "source /home/vagrant/.rvm/scripts/rvm && rvm --version"').and_return(true)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'creates user rvmrc configuration' do
    expect(chef_run).to create_template('/home/vagrant/.rvmrc')
  end
end
