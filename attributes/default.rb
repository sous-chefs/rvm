#
# Cookbook Name:: rvm
# Attributes:: default
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
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

default['rvm']['root_path']     = "/usr/local/rvm"
default['rvm']['group_id']      = 'default'
default['rvm']['group_users']   = []
default['rvm']['rvmrc']         = Hash.new

default['rvm']['installer_url'] = "https://rvm.beginrescueend.com/install/rvm"

default['rvm']['branch']  = nil
default['rvm']['version'] = nil

default['rvm']['upgrade'] = "none"

# a hook to disable installing any default/additional rubies
default['rvm']['install_rubies'] = "true"

# ruby that will get installed and set to `rvm use default`.
default['rvm']['default_ruby'] = "ruby-1.9.2-p180"

# list of additional rubies that will be installed
default['rvm']['rubies'] = []

# list of gems to be installed in global gemset of all rubies
default['rvm']['global_gems'] = [
  { 'name' => "bundler" },
  { 'name' => "rake" }
]

# hash of gemsets and their list of additional gems to be installed.
default['rvm']['gems'] = Hash.new

# default rvm_gem_options (skip rdoc/ri generation)
default['rvm']['rvm_gem_options'] = "--no-rdoc --no-ri"
