unified_mode true
provides :rvm_ruby

use '_partial/_user'

property :ruby_string,
         String,
         name_property: true,
         description: 'Ruby version to install (e.g., ruby-3.2.0, jruby-9.4.0.0)'

property :default,
         [true, false],
         default: false,
         description: 'Set this Ruby as the default'

property :patch,
         String,
         description: 'Patch to apply during Ruby installation'

action :install do
  rvm_bin_path = rvm_bin(new_resource.user)
  env = rvm_env(new_resource.user)

  execute "rvm_install_ruby_#{new_resource.ruby_string}" do
    command build_install_command
    environment env
    user new_resource.user if new_resource.user
    not_if { ruby_installed?(new_resource.ruby_string, new_resource.user) }
  end

  if new_resource.default
    execute "rvm_set_default_#{new_resource.ruby_string}" do
      command "#{rvm_bin_path} alias create default #{new_resource.ruby_string}"
      environment env
      user new_resource.user if new_resource.user
      not_if { default_ruby(new_resource.user) == new_resource.ruby_string }
    end
  end
end

action :uninstall do
  rvm_bin_path = rvm_bin(new_resource.user)
  env = rvm_env(new_resource.user)

  execute "rvm_uninstall_ruby_#{new_resource.ruby_string}" do
    command "#{rvm_bin_path} remove #{new_resource.ruby_string}"
    environment env
    user new_resource.user if new_resource.user
    only_if { ruby_installed?(new_resource.ruby_string, new_resource.user) }
  end
end

action_class do
  include RvmCookbook::RvmHelper

  def build_install_command
    cmd = "#{rvm_bin(new_resource.user)} install #{new_resource.ruby_string}"
    cmd += " --patch #{new_resource.patch}" if new_resource.patch
    cmd
  end
end
