#
# Cookbook Name:: rvm
# Provider:: gem
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

action :install do
  ruby_string = new_resource.ruby_string

  # get the actual ruby string that corresponds to "default"
  if ruby_string.start_with?("default")
    ruby_string.sub!(/default/, current_ruby_default)
  end

  # ensure ruby is installed and gemset exists
  e = rvm_environment ruby_string do
    action :nothing
  end
  e.run_action(:create)

  g = gem_package new_resource.gem do
    gem_binary  "rvm #{ruby_string} gem"
    source      new_resource.source if new_resource.source
    options     new_resource.options if new_resource.options
    version     new_resource.version if new_resource.version
    action      :nothing
  end
  g.run_action(:install)
end
