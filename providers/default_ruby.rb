#
# Cookbook Name:: rvm
# Provider:: default_ruby
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
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

action :create do
  rubie = new_resource.ruby_string

  if ruby_unknown?(rubie)
    Chef::Log.warn("rvm_default_ruby[#{rubie}] is either not fully " +
      "qualified or not known . Use `rvm list known` to get a full list.")
  elsif ruby_default?(rubie)
    Chef::Log.debug("rvm_ruby[#{rubie}] is already default, so skipping")
  else
    if ruby_installed?(rubie)
      Chef::Log.info("Setting default ruby to rvm_ruby[#{rubie}]")
      env = RVM::Environment.new
      env.rvm :use, rubie, :default => true
    else
      Chef::Log.warn("rvm_ruby[#{rubie}] was not installed, so could not " +
        "be set as default ruby")
    end
  end
end
