require 'spec_helper'

describe 'rvm_gem' do
  step_into :rvm_gem
  platform 'ubuntu'

  context 'install a gem' do
    recipe do
      rvm_gem 'bundler' do
        ruby_string '3.2.0'
        action :install
      end
    end

    before do
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_installed?).and_return(true)
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:ruby_installed?).and_return(true)
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_command).and_return(true)
      allow_any_instance_of(Chef::Resource).to receive(:gem_installed?).and_return(false)
    end

    it { is_expected.to install_rvm_gem('bundler') }
  end

  context 'remove a gem' do
    recipe do
      rvm_gem 'rake' do
        ruby_string '3.2.0'
        action :remove
      end
    end

    before do
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_installed?).and_return(true)
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:ruby_installed?).and_return(true)
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_command).and_return(true)
      allow_any_instance_of(Chef::Resource).to receive(:gem_installed?).and_return(true)
    end

    it { is_expected.to remove_rvm_gem('rake') }
  end
end
