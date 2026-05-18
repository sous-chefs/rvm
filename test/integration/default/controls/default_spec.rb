# frozen_string_literal: true

control 'rvm-system-install-01' do
  impact 1.0
  title 'RVM system installation is created'

  describe directory('/usr/local/rvm') do
    it { should exist }
  end

  describe file('/usr/local/rvm/bin/rvm') do
    it { should exist }
    it { should be_executable }
  end

  describe file('/etc/rvmrc') do
    it { should exist }
    its('content') { should match(/rvm_path/) }
    its('content') { should match(/rvm_gem_options/) }
  end

  describe group('rvm') do
    it { should exist }
  end
end
