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
  rubie = select_ruby(new_resource.ruby_string)

  if ruby_unknown?(rubie)
    Chef::Log.warn("rvm_ruby[#{rubie}] is either not fully qualified or not " +
      "known . Use `rvm list known` to get a full list.")
  elsif ruby_installed?(rubie)
    Chef::Log.debug("rvm_ruby[#{rubie}] is already installed, so skipping")
  else
    install_start = Time.now

    install_ruby_dependencies rubie

    Chef::Log.info("Building rvm_ruby[#{rubie}], this could take awhile...")

    if RVM.install(rubie)
      Chef::Log.info("Installation of rvm_ruby[#{rubie}] was successful.")
      env = RVM::Environment.new
      env.use rubie
      update_installed_rubies

      Chef::Log.info("Importing initial gemsets for rvm_ruby[#{rubie}]")
      if env.gemset_initial
        Chef::Log.debug("Initial gemsets for rvm_ruby[#{rubie}] are installed")
      else
        Chef::Log.warn(
          "Failed to install initial gemsets for rvm_ruby[#{rubie}] ")
      end
    else
      Chef::Log.warn("Failed to install rvm_ruby[#{rubie}]. " +
        "Check logs in #{RVM.path}/log/#{rubie}")
    end

    Chef::Log.debug("rvm_ruby[#{rubie}] build time was " +
      "#{(Time.now - install_start)/60.0} minutes.")
  end
end

action :uninstall do
  rubie = new_resource.ruby_string

  if ruby_unknown?(rubie)
    Chef::Log.warn("rvm_ruby[#{rubie}] is either not fully qualified or not " +
      "known . Use `rvm list known` to get a full list.")
  elsif ruby_installed?(rubie)
    Chef::Log.info("Uninstalling rvm_ruby[#{rubie}]")

    if RVM.uninstall(rubie)
      update_installed_rubies
      Chef::Log.debug("Uninstallation of rvm_ruby[#{rubie}] was successful.")
    else
      Chef::Log.warn("Failed to uninstall rvm_ruby[#{rubie}]. " +
        "Check logs in #{RVM.path}/log/#{rubie}")
    end
  else
    Chef::Log.debug("rvm_ruby[#{rubie}] was not installed, so skipping")
  end
end

action :remove do
  rubie = new_resource.ruby_string

  if ruby_unknown?(rubie)
    Chef::Log.warn("rvm_ruby[#{rubie}] is either not fully qualified or not " +
      "known . Use `rvm list known` to get a full list.")
  elsif ruby_installed?(rubie)
    Chef::Log.info("Removing rvm_ruby[#{rubie}]")

    if RVM.remove(rubie)
      update_installed_rubies
      Chef::Log.debug("Removal of rvm_ruby[#{rubie}] was successful.")
    else
      Chef::Log.warn("Failed to remove rvm_ruby[#{rubie}]. " +
        "Check logs in #{RVM.path}/log/#{rubie}")
    end
  else
    Chef::Log.debug("rvm_ruby[#{rubie}] was not installed, so skipping")
  end
end
