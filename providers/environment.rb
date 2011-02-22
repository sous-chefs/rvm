#
# Cookbook Name:: rvm
# Provider:: environment
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
  rubie   = select_ruby(ruby_string)
  gemset  = select_gemset(ruby_string)

  if ruby_unknown?(rubie)
    Chef::Log.warn("rvm_environment[#{rubie}] is either not fully " +
      "qualified or not known . Use `rvm list known` to get a full list.")
  else
    if gemset
      # ensure gemset is created, if specified
      unless gemset_exists?(:ruby => rubie, :gemset => gemset)
        g = rvm_gemset gemset do
          ruby_string   rubie
          action        :nothing
        end
        g.run_action(:create)
      end
    else
      # ensure ruby version is installed
      unless ruby_installed?(rubie)
        r = rvm_ruby rubie do
          action :nothing
        end
        r.run_action(:install)
      end
    end
  end
end
