unified_mode true

action :install do
  chef_gem 'rvm' do
    action :install
    version '>= 1.11.3.6'
  end

  require 'rvm'

  create_rvm_shell_chef_wrapper
  create_rvm_chef_user_environment

  include Chef::RVM::ShellHelpers
  include Chef::RVM::StringHelpers

  cmd = Mixlib::ShellOut.new('which gpg2 || which gpg')
  cmd.run_command

  if cmd.exitstatus == 0
    gpg_command = cmd.stdout.chomp

    exec = Chef::Resource::Execute.new 'Add RVM gpg key', run_context
    exec.command "#{gpg_command} --keyserver hkp://keys.gnupg.net --recv-keys #{node['rvm']['gpg_key']}"
    exec.user user['user']
    exec.environment 'HOME' => user['home']
    exec.guard_interpreter :bash
    exec.not_if "#{gpg_command} -k #{node['rvm']['gpg_key']} > /dev/null", user: user['user'], environment: { 'HOME' => user['home'] }
    exec.run_action :run
  else
    Chef::Log.info 'Skipping adding RVM key because gpg/gpg2 not installed'
  end

  rvm_installation(user.to_s) do
    %w(installer_url installer_flags install_pkgs rvmrc_template_source
      rvmrc_template_cookbook rvmrc_env action
    ).each do |attr|
      # if user hash attr is set, then set the resource attr
      send(attr, opts[attr]) if opts.fetch(attr, false)
    end
  end
end
