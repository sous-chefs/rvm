#
# Cookbook Name:: rvm
# Provider:: ruby
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
  rubie = new_resource.ruby_string

  if ruby_installed?(rubie)
    Chef::Log.debug("RVM ruby #{rubie} is already installed, so skipping")
  else
    Chef::Log.info("RVM ruby #{rubie} installation in progress. " +
      "This could take awhile...")

    if RVM.install(rubie)
      Chef::Log.info("Successful installation of RVM ruby #{rubie}")
    else
      Chef::Log.warn("Failed to install RVM ruby #{rubie}. " +
        "Check RVM logs here: #{RVM.path}/log/#{rubie}")
    end
  end
end
