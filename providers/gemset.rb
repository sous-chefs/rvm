#
# Cookbook Name:: rvm
# Provider:: gemset
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
  if new_resource.ruby_string
    rubie   = normalize_ruby_string(new_resource.ruby_string)
    gemset  = new_resource.gemset
  else
    rubie   = select_ruby(normalize_ruby_string(new_resource.gemset))
    gemset  = select_gemset(normalize_ruby_string(new_resource.gemset))
  end
  full_name = "#{rubie}@#{gemset}"

  unless ruby_installed?(rubie)
    r = rvm_ruby rubie do
      action :nothing
    end
    r.run_action(:install)
  end

  if gemset_exists?(:ruby => rubie, :gemset => gemset)
    Chef::Log.debug("rvm_gemset[#{full_name}] already exists, so skipping")
  else
    Chef::Log.info("Creating rvm_gemset[#{full_name}]")

    env = RVM::Environment.new
    env.use rubie
    if env.gemset_create gemset
      Chef::Log.debug("Creation of rvm_gemset[#{full_name}] was successful.")
    else
      Chef::Log.warn("Failed to create rvm_gemset[#{full_name}].")
    end
  end
end

action :delete do
  if new_resource.ruby_string
    rubie   = normalize_ruby_string(new_resource.ruby_string)
    gemset  = new_resource.gemset
  else
    rubie   = select_ruby(normalize_ruby_string(new_resource.gemset))
    gemset  = select_gemset(normalize_ruby_string(new_resource.gemset))
  end
  full_name = "#{rubie}@#{gemset}"

  if gemset_exists?(:ruby => rubie, :gemset => gemset)
    Chef::Log.info("Deleting rvm_gemset[#{full_name}]")

    env = RVM::Environment.new
    env.use rubie
    if env.gemset_delete gemset
      Chef::Log.debug("Deletion of rvm_gemset[#{full_name}] was successful.")
    else
      Chef::Log.warn("Failed to delete rvm_gemset[#{full_name}].")
    end
  else
    Chef::Log.debug("rvm_gemset[#{full_name}] does not exist, so skipping")
  end
end
