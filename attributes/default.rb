# ruby that will get installed and set to `rvm use default`.
default['rvm']['default_ruby']      = 'ruby-1.9.3-p547'
default['rvm']['user_default_ruby'] = 'ruby-1.9.3-p547'

# list of additional rubies that will be installed
default['rvm']['rubies']      = []
default['rvm']['user_rubies'] = []

# list of gems to be installed in global gemset of all rubies
global_gems = [
  { 'name' => 'bundler' },
]
default['rvm']['global_gems']       = global_gems.dup
default['rvm']['user_global_gems']  = global_gems.dup

# hash of gemsets and their list of additional gems to be installed.
default['rvm']['gems']      = {}
default['rvm']['user_gems'] = {}

# hash of rvmrc options
default['rvm']['rvmrc_env'] = { 'rvm_gem_options' => '--no-document' }

# a hash of user hashes, each an isolated per-user RVM installation
default['rvm']['installs'] = {}

# system-wide installer options
default['rvm']['installer_url'] = 'https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer'
default['rvm']['version'] = 'stable'

# Autolib mode, see https://rvm.io/rvm/autolibs
default['rvm']['autolib_mode'] = 3

# extra system-wide tunables
default['rvm']['root_path']     = '/usr/local/rvm'
default['rvm']['group_id']      = 'default'
default['rvm']['group_users']   = []

case node['platform']
when 'redhat', 'centos', 'fedora', 'scientific', 'amazon', 'oracle'
  node.override['rvm']['install_pkgs']   = %w(sed grep tar gzip bzip2 bash curl git)
when 'debian', 'ubuntu', 'suse'
  node.override['rvm']['install_pkgs']   = %w(sed grep tar gzip bzip2 bash curl git-core)
when 'gentoo'
  node.override['rvm']['install_pkgs']   = %w(git)
when 'mac_os_x'
  node.override['rvm']['install_pkgs']   = %w(git)
end
