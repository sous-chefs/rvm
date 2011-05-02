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
  ruby_string = new_resource.ruby_string
  ruby_string = "system" if system_ruby?(ruby_string)
  rubie   = select_ruby(ruby_string)
  gemset  = select_gemset(ruby_string)

  if rubie != "system" && ruby_unknown?(rubie)
    Chef::Log.warn("rvm_default_ruby[#{rubie}] is either not fully " +
      "qualified or not known . Use `rvm list known` to get a full list.")
  elsif ruby_default?(ruby_string)
    Chef::Log.debug("rvm_ruby[#{ruby_string}] is already default, so skipping")
  else
    # ensure ruby is installed and gemset exists (if specified)
    unless env_exists?(ruby_string)
      e = rvm_environment ruby_string do
        action :nothing
      end
      e.run_action(:create)
    end

    Chef::Log.info("Setting default ruby to rvm_ruby[#{ruby_string}]")
    env = RVM::Environment.new
    env.rvm :use, ruby_string, :default => true
  end
end
