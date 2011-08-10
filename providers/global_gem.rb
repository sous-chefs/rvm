#
# Cookbook Name:: rvm
# Provider:: global_gem
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

include Chef::RVM::RubyHelpers

def load_current_resource
  @rvm_env      = ::RVM::ChefUserEnvironment.new(new_resource.user)
end

action :install do
  # add gem entry into global.gems
  update_global_gems_file :create

  # install gem in all rubies in global gemsets
  installed_rubies.each do |rubie|
    gem_package_wrapper :install, "#{rubie}@global"
  end
end

action :upgrade do
  # add gem entry into global.gems
  update_global_gems_file :create

  # upgrade gem in all rubies in global gemsets
  installed_rubies.each do |rubie|
    gem_package_wrapper :upgrade, "#{rubie}@global"
  end
end

action :remove do
  # remove gem entry from global.gems
  update_global_gems_file :remove

  # remove gem in all rubies in global gemsets
  installed_rubies.each do |rubie|
    gem_package_wrapper :remove, "#{rubie}@global"
  end
end

action :purge do
  # remove gem entry from global.gems
  update_global_gems_file :remove

  # remove gem in all rubies in global gemsets
  installed_rubies.each do |rubie|
    gem_package_wrapper :purge, "#{rubie}@global"
  end
end

private

##
# Wraps the rvm_gem resource
#
# @param [Symbol] action to be performed with gem_package provider
# @param [optional, String, #to_s] the fully qualifed rvm string
def gem_package_wrapper(exec_action, ruby_global_gemset)
  g = rvm_gem new_resource.package_name do
    ruby_string ruby_global_gemset
    source      new_resource.source if new_resource.source
    options     new_resource.options if new_resource.options
    version     new_resource.version if new_resource.version
    gem_binary  new_resource.gem_binary if new_resource.gem_binary
    user        new_resource.user
    action      :nothing
  end
  g.run_action(exec_action)
end

##
# Updates global.gems file to create or remove a gem entry
#
# @oaram [Symbol] action to :create or :remove the gem from the file
def update_global_gems_file(exec_action)
  gem               = new_resource.package_name
  user_dir          = Etc.getpwnam(new_resource.user).dir if new_resource.user
  global_gems_file  = if new_resource.user
                        "#{user_dir}/.rvm/gemsets/global.gems"
                      else
                        "#{node['rvm']['root_path']}/gemsets/global.gems"
                      end

  if exec_action == :create
    e = execute "Add #{gem} to #{global_gems_file}" do
      if new_resource.user
        user    new_resource.user
        group   Etc.getpwnam(new_resource.user).gid
        environment ({ 'USER' => new_resource.user, 'HOME' => user_dir })
      else
        user    "root"
        group   "rvm"
      end

      command   %{echo "#{gem}" >> "#{global_gems_file}"}
      action    :nothing

      not_if    %{grep -q "^#{gem}" "#{global_gems_file}"}
    end
    e.run_action(:run)
  end
end
