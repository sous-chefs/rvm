# frozen_string_literal: true

control 'rvm-user-install-01' do
  impact 1.0
  title 'RVM user installation is created'

  describe user('vagrant') do
    it { should exist }
  end

  describe directory('/home/vagrant/.rvm') do
    it { should exist }
  end

  describe file('/home/vagrant/.rvmrc') do
    it { should exist }
    its('content') { should match(%r{/home/vagrant/.rvm}) }
  end
end
