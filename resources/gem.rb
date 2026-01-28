unified_mode true
provides :rvm_gem

use '_partial/_user'

property :package_name,
         String,
         name_property: true,
         description: 'Name of the gem to install'

property :version,
         String,
         description: 'Version of the gem to install'

property :ruby_string,
         String,
         default: 'default',
         description: 'Ruby version to install the gem for'

property :gemset,
         String,
         description: 'Gemset to install the gem into'

property :source,
         String,
         description: 'Custom gem source URL'

property :options,
         String,
         description: 'Additional options to pass to gem install'

default_action :install

action :install do
  execute "rvm_gem_install_#{new_resource.package_name}" do
    command build_gem_command('install')
    environment rvm_env(new_resource.user)
    user new_resource.user if new_resource.user
    not_if { gem_installed? }
  end
end

action :remove do
  execute "rvm_gem_remove_#{new_resource.package_name}" do
    command build_gem_command('uninstall')
    environment rvm_env(new_resource.user)
    user new_resource.user if new_resource.user
    only_if { gem_installed? }
  end
end

action :upgrade do
  execute "rvm_gem_upgrade_#{new_resource.package_name}" do
    command build_gem_command('update')
    environment rvm_env(new_resource.user)
    user new_resource.user if new_resource.user
    only_if { gem_installed? }
  end
end

action_class do
  include RvmCookbook::RvmHelper

  def ruby_with_gemset
    if new_resource.gemset
      "#{new_resource.ruby_string}@#{new_resource.gemset}"
    else
      new_resource.ruby_string
    end
  end

  def build_gem_command(action)
    rvm_bin_path = rvm_bin(new_resource.user)
    cmd = "#{rvm_bin_path} #{ruby_with_gemset} do gem #{action} #{new_resource.package_name}"
    cmd += " --version '#{new_resource.version}'" if new_resource.version && action == 'install'
    cmd += " --source #{new_resource.source}" if new_resource.source && action == 'install'
    cmd += " #{new_resource.options}" if new_resource.options
    cmd += ' --no-document' if action == 'install'
    cmd += ' -x -I' if action == 'uninstall'
    cmd
  end

  def gem_installed?
    rvm_bin_path = rvm_bin(new_resource.user)
    cmd = shell_out(
      "#{rvm_bin_path} #{ruby_with_gemset} do gem list -i #{new_resource.package_name}",
      environment: rvm_env(new_resource.user),
      user: new_resource.user
    )
    cmd.exitstatus.zero? && cmd.stdout.strip == 'true'
  end
end
