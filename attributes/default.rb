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

default[:rvm][:root_path] = "/usr/local/rvm"
default[:rvm][:group_users] = []
default[:rvm][:rvmrc] = Hash.new

# ruby that will get set to `rvm use default`. Use fully qualified ruby names.
default[:rvm][:default_ruby] = "ree-1.8.7"

# list of rubies that will be installed
default[:rvm][:rubies] = [ select_ruby(rvm[:default_ruby]) ]

# hash of gemsets and their list of gems to be installed. If default_ruby
# contains a gemset like ree-1.8.7@awesome then strip the gemset to get at the
# global gemset for that ruby.
default[:rvm][:gems] = {
  "#{select_ruby(rvm[:default_ruby])}@global" => [
    { :name => "bundler" }
  ]
}

