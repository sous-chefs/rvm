require 'spec_helper'

describe 'rvm_ruby' do
  step_into :rvm_ruby
  platform 'ubuntu'

  context 'install a ruby version' do
    recipe do
      rvm_ruby '3.2.0' do
        action :install
      end
    end

    before do
      # Stub the RVM helper methods
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_installed?).and_return(true)
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:ruby_installed?).and_return(false)
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:default_ruby).and_return(nil)
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_command).and_return(true)
    end

    it { is_expected.to install_rvm_ruby('3.2.0') }
  end

  context 'uninstall a ruby version' do
    recipe do
      rvm_ruby '3.1.0' do
        action :uninstall
      end
    end

    before do
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_installed?).and_return(true)
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:ruby_installed?).and_return(true)
      allow_any_instance_of(RvmCookbook::RvmHelper).to receive(:rvm_command).and_return(true)
    end

    it { is_expected.to uninstall_rvm_ruby('3.1.0') }
  end
end
