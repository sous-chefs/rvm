#
# Cookbook Name:: rvm
# Recipe:: default
#
# Copyright 2010, 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'rubygems/dependency_installer'

# install rvm api gem during chef compile phase
if Gem.source_index.find_name("rvm").empty?
  Chef::Log.info("Installing RVM gem")
  Gem::DependencyInstaller.new.install("rvm")
  begin
    Gem.activate("rvm")
    require 'rvm'
  rescue LoadError
    Chef::Application.fatal!(
      "There was a problem installing and loading the 'rvm' gem.")
  end
else
  Chef::Log.debug("RVM gem was installed, so installation skipped")
end

include_recipe "rvm::system"

if node['rvm']['install_rubies'] == true || node['rvm']['install_rubies'] == "true"
  # set a default ruby
  rvm_default_ruby node['rvm']['default_ruby']

  # install additional rubies
  node['rvm']['rubies'].each do |rubie|
    rvm_ruby rubie
  end

  # install global gems
  node['rvm']['global_gems'].each do |gem|
    rvm_global_gem gem[:name] do
      version   gem[:version] if gem[:version]
      action    gem[:action]  if gem[:action]
      options   gem[:options] if gem[:options]
      source    gem[:source]  if gem[:source]
    end
  end

  # install additional gems
  node['rvm']['gems'].each_pair do |rstring, gems|
    rvm_environment rstring

    gems.each do |gem|
      rvm_gem gem[:name] do
        ruby_string   rstring
        version       gem[:version] if gem[:version]
        action        gem[:action]  if gem[:action]
        options       gem[:options] if gem[:options]
        source        gem[:source]  if gem[:source]
      end
    end
  end
end
