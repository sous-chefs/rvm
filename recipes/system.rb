#
# Cookbook Name:: rvm
# Recipe:: system
#
# Copyright 2010, 2011 Fletcher Nichol
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

# thanks to:
# - http://www.agileweboperations.com/chef-rvm-ruby-enterprise-edition-as-default-ruby/
# - http://github.com/denimboy/xprdev/blob/master/rvm/recipes/default.rb

script_flags = ""
if node['rvm']['version']
  script_flags += " --version #{node['rvm']['version']}"
end
if node['rvm']['branch']
  script_flags += " --branch #{node['rvm']['branch']}"
end

upgrade_strategy = if node['rvm']['upgrade'].nil? || node['rvm']['upgrade'] == false
  "none"
else
  node['rvm']['upgrade']
end

pkgs = %w{ sed grep tar gzip bzip2 bash curl }
case node[:platform]
  when "centos","redhat","fedora"
    pkgs << "git"
  when "debian","ubuntu","suse"
    pkgs << "git-core"
end

pkgs.each do |pkg|
  package pkg
end

execute "install system-wide RVM" do
  user      "root"
  command   <<-CODE
    bash -c "bash <( curl -Ls #{node['rvm']['installer_url']} )#{script_flags}"
  CODE
  not_if    rvm_wrap_cmd(%{type rvm | head -1 | grep -q '^rvm is a function$'})
end

template  "/etc/rvmrc" do
  source  "rvmrc.erb"
  owner   "root"
  group   "rvm"
  mode    "0644"
end

execute "upgrade RVM to #{upgrade_strategy}" do
  user      "root"
  command   rvm_wrap_cmd(%{rvm get #{upgrade_strategy}})
  only_if   { %w{ latest head }.include? upgrade_strategy }
end
