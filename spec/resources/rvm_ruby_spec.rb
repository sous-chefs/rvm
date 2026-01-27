require 'spec_helper'

describe 'rvm_ruby' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['rvm_ruby']) do |node|
      node.automatic['platform_family'] = 'debian'
    end.converge('test::system_install')
  end

  before do
    # Stub the RVM helper methods
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_installed?).and_return(true)
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:ruby_installed?).and_return(false)
    allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:default_ruby).and_return(nil)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
