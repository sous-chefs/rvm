require 'spec_helper'

describe RvmCookbook::RvmHelper do
  let(:helper_class) do
    Class.new do
      include RvmCookbook::RvmHelper
    end
  end

  let(:helper) { helper_class.new }

  describe '#rvm_path' do
    context 'for system installation' do
      it 'returns /usr/local/rvm' do
        expect(helper.rvm_path).to eq('/usr/local/rvm')
      end
    end

    context 'for user installation' do
      before do
        allow(helper).to receive(:user_home).with('testuser').and_return('/home/testuser')
      end

      it 'returns the user rvm path' do
        expect(helper.rvm_path('testuser')).to eq('/home/testuser/.rvm')
      end
    end
  end

  describe '#rvm_bin' do
    it 'returns the system rvm binary path' do
      expect(helper.rvm_bin).to eq('/usr/local/rvm/bin/rvm')
    end

    it 'returns the user rvm binary path' do
      allow(helper).to receive(:user_home).with('testuser').and_return('/home/testuser')
      expect(helper.rvm_bin('testuser')).to eq('/home/testuser/.rvm/bin/rvm')
    end
  end

  describe '#rvm_env' do
    it 'returns environment hash for system' do
      env = helper.rvm_env
      expect(env['rvm_path']).to eq('/usr/local/rvm')
      expect(env['HOME']).to be_nil
    end

    it 'returns environment hash for user' do
      allow(helper).to receive(:user_home).with('testuser').and_return('/home/testuser')
      env = helper.rvm_env('testuser')
      expect(env['rvm_path']).to eq('/home/testuser/.rvm')
      expect(env['HOME']).to eq('/home/testuser')
    end
  end

  describe '#rvm_installed?' do
    it 'returns true when rvm binary exists' do
      allow(File).to receive(:exist?).with('/usr/local/rvm/bin/rvm').and_return(true)
      expect(helper.rvm_installed?).to be true
    end

    it 'returns false when rvm binary does not exist' do
      allow(File).to receive(:exist?).with('/usr/local/rvm/bin/rvm').and_return(false)
      expect(helper.rvm_installed?).to be false
    end
  end
end
