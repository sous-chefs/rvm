require 'spec_helper'

describe 'rvm_ruby' do
  let(:rvm_ruby_default) do
    ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04',
        step_into: ['rvm_ruby']
    ).converge('rvm_wrapper::default')
  end

  context 'without rvm installed' do
    it 'fetches the latest installer' do
      expect(rvm_ruby_default).to install_rvm_ruby('2.3.0')
    end
  end
end
