#
# Cookbook Name:: rvm
# Provider:: wrapper
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
  ruby_string = normalize_ruby_string(new_resource.ruby_string)
  if new_resource.binary.nil?
    binaries = new_resource.binaries || []
  else
    binaries = [ new_resource.binary ] || []
  end

  # ensure ruby is installed and gemset exists
  unless env_exists?(ruby_string)
    e = rvm_environment ruby_string do
      action :nothing
    end
    e.run_action(:create)
  end

  env = RVM::Environment.new
  env.use ruby_string

  binaries.each do |b|
    full_bin = "#{new_resource.prefix}_#{b}"
    resource_name = "rvm_wrapper[#{full_bin}::#{ruby_string}]"
    script = ::File.join(::File.dirname(node['rvm']['root_path']), "bin", full_bin)

    if ::File.exists?(script)
      Chef::Log.debug("#{resource_name} already exists, so updating")
    else
      Chef::Log.info("Creating #{resource_name}")
    end

    if env.wrapper ruby_string, new_resource.prefix, b
      Chef::Log.debug("Creation/Update of #{resource_name} was successful.")
    else
      Chef::Log.warn("Failed to create/update #{resource_name}.")
    end
  end
end
