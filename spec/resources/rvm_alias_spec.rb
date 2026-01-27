require 'spec_helper'

describe 'rvm_alias' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['rvm_alias']) do |node|
      node.automatic['platform_family'] = 'debian'
    end.converge('test::global')
  end

  before do
    # Stub RVM helper methods
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_installed?).and_return(true)
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:ruby_installed?).and_return(true)
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:alias_exists?).and_return(false)
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:alias_target).and_return(nil)
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_command).and_return(true)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
