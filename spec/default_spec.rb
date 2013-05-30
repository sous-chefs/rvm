require 'spec_helper'

describe 'rvm' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'rvm' }

  it 'includes the chef_gem recipe' do
    expect(chef_run).to install_chef_gem_package 'rvm'
  end
end
