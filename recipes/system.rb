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

# For more information on the 'action :nothing' and 'run_action(:foo)' usages see
# http://wiki.opscode.com/display/chef/Evaluate+and+Run+Resources+at+Compile+Time

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

gem_package_included = node.recipe?("rvm::gem_package")

pkgs = %w{ sed grep tar gzip bzip2 bash curl }
case node[:platform]
  when "centos","redhat","fedora"
    pkgs << "git"
  when "debian","ubuntu","suse"
    pkgs << "git-core"
end

pkgs.each do |pkg|
  p = package pkg do
    # excute in compile phase if gem_package recipe is requested
    if gem_package_included
      action :nothing
    else
      action :install
    end
  end
  p.run_action(:install) if gem_package_included
end

# Build the rvm group ahead of time, if it is set. This allows avoiding
# collision with later processes which may set a guid explicitly
if node['rvm']['group_id'] != 'default'
  g = group 'rvm' do
    group_name 'rvm'
    gid        node['rvm']['group_id']
    action     :nothing
  end
  g.run_action(:create)
end

i = execute "install system-wide RVM" do
  user      "root"
  command   <<-CODE
    bash -c "bash <( curl -Ls #{node['rvm']['installer_url']} )#{script_flags}"
  CODE
  not_if    rvm_wrap_cmd(%{type rvm | head -1 | grep -q '^rvm is a function$'})

  # excute in compile phase if gem_package recipe is requested
  if gem_package_included
    action :nothing
  else
    action :run
  end
end
i.run_action(:run) if gem_package_included

t = template  "/etc/rvmrc" do
  source  "rvmrc.erb"
  owner   "root"
  group   "rvm"
  mode    "0644"

  # excute in compile phase if gem_package recipe is requested
  if gem_package_included
    action :nothing
  else
    action :create
  end
end
t.run_action(:create) if gem_package_included

u = execute "upgrade RVM to #{upgrade_strategy}" do
  user      "root"
  command   rvm_wrap_cmd(%{rvm get #{upgrade_strategy}})
  only_if   { %w{ latest head }.include? upgrade_strategy }

  # excute in compile phase if gem_package recipe is requested
  if gem_package_included
    action :nothing
  else
    action :run
  end
end
u.run_action(:run) if gem_package_included
