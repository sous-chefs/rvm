# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'berkshelf/vagrant'
require_relative 'test/jamie/vagrant'

Vagrant::Config.run do |config|
  Jamie::Vagrant.define_vms(config)
end
