#
# Cookbook Name:: rvm
# Recipe:: system
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

# thanks to:
# - http://www.agileweboperations.com/chef-rvm-ruby-enterprise-edition-as-default-ruby/
# - http://github.com/denimboy/xprdev/blob/master/rvm/recipes/default.rb

if node[:rvm][:version] && node[:rvm][:revision] == "HEAD"
  # rvm/version overrides the rvm/revision default
  install_command = <<-CODE
    bash -c "bash <( curl -L #{node[:rvm][:system_installer_url]} ) \
      --version '#{node[:rvm][:version]}'"
  CODE
elsif node[:rvm][:revision] == "HEAD"
  # rvm/version == HEAD runs the default installer
  install_command = <<-CODE
    bash -c "bash < <( curl -L #{node[:rvm][:system_installer_url]} )"
  CODE
else
  # rvm/revision gets used
  install_command = <<-CODE
    bash -c "bash <( curl -L #{node[:rvm][:system_installer_url]} ) \
      --revision '#{node[:rvm][:revision]}'"
  CODE
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

template "/etc/profile.d/rvm.sh" do
  source  "rvm.sh.erb"
  owner   "root"
  group   "root"
  mode    "0644"
end

group "rvm" do
  members node[:rvm][:group_users]
  append  true
end

unless node[:rvm][:rvmrc].empty?
  lines = []
  node[:rvm][:rvmrc].each_pair { |k,v|  lines << "#{k.to_s}=#{v.to_s}" }

  template  "/etc/rvmrc" do
    source  "rvmrc.erb"
    owner   "root"
    group   "root"
    mode    "0644"
    variables(:lines => lines.sort.join("\n"))
  end
end

execute "install system-wide RVM" do
  user      "root"
  command   install_command
  not_if    rvm_wrap_cmd(%{type rvm | head -1 | grep -q '^rvm is a function$'})
end

execute "upgrade RVM to #{node[:rvm][:upgrade]}" do
  user      "root"
  command   rvm_wrap_cmd(%{rvm get #{node[:rvm][:upgrade]}})
  only_if do
    %{ latest head }.include? node[:rvm][:upgrade]
  end
end
