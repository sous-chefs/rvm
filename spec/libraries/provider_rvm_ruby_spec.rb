require 'spec_helper'

describe 'rvm_ruby' do
  let(:rvm_ruby_default) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      step_into: ['rvm_ruby']
    ).converge('rvm_wrapper::default')
  end

  context 'without rvm installed' do
    it 'fetches the latest installer' do
      expect(rvm_ruby_default).to create_remote_file("#{Chef::Config[:file_cache_path]}/rvm_installer.sh")
    end
  end
end
