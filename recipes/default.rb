#
# Cookbook Name:: rvm
# Recipe:: default
#
# Copyright 2010, Fletcher Nichol
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
include_recipe "rvm::rubies"
include_recipe "rvm::default_ruby"
include_recipe "rvm::gems"
