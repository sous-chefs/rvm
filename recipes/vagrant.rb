#
# Cookbook Name:: rvm
# Recipe:: vagrant
#
# Copyright 2011, Fletcher Nichol
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

template "/usr/local/bin/chef-client" do
  source    "vagrant-chef-client-wrapper.erb"
  owner     "root"
  group     "root"
  mode      "0755"
end

template "/usr/local/bin/chef-solo" do
  source    "vagrant-chef-solo-wrapper.erb"
  owner     "root"
  group     "root"
  mode      "0755"
end

group "rvm" do
  members ["vagrant"]
  append  true
end

# Resolves a conflict between rvm::system and the sudo cookbook.
# https://github.com/fnichol/chef-rvm/issues/121
directory "/opt/vagrant_ruby/bin" do
  owner "root"
  group "root"
  recursive true
  mode 755
  not_if { ::File.exists?("/opt/vagrant_ruby/bin") }
end

["chef-client", "chef-solo"].each do |name|
  link "/opt/vagrant_ruby/bin/#{name}" do
    to "/opt/chef/bin/#{name}"
    not_if { ::File.exists?("/opt/vagrant_ruby/bin/#{name}") }
  end
end
