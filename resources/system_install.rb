unified_mode true
provides :rvm_system_install

use '_partial/_gpg'
use '_partial/_rvm_install'

property :rvm_group_users,
         Array,
         default: [],
         description: 'Users to add to the rvm group'

action :install do
  # Create rvm group
  group 'rvm' do
    system true
  end

  # Install GPG using the gpg cookbook
  gpg_install 'rvm'

  # Import RVM GPG keys for each key fingerprint
  new_resource.gpg_key.split.each do |key_fingerprint|
    gpg_key "rvm_key_#{key_fingerprint}" do
      keyserver new_resource.keyserver
      key_fingerprint key_fingerprint
      action :import
    end
  end

  # Install required packages for RVM itself
  package rvm_install_packages

  # Install Ruby build dependencies
  # Pre-installing these avoids RVM autolibs issues on EL9 distributions
  package ruby_build_packages

  # Download the RVM installer
  remote_file rvm_installer_path do
    source new_resource.installer_url
    mode '0755'
    action :create
  end

  # Install RVM system-wide
  execute 'install_rvm_system' do
    command "#{rvm_installer_path} #{new_resource.version} --ignore-dotfiles"
    environment({
      'rvm_path' => '/usr/local/rvm',
      'DEBIAN_FRONTEND' => 'noninteractive',
      'HOME' => '/root',
    })
    creates '/usr/local/rvm/bin/rvm'
  end

  # Create rvmrc configuration
  template '/etc/rvmrc' do
    source 'rvmrc.erb'
    cookbook 'rvm'
    mode '0644'
    variables(rvmrc_env: new_resource.rvmrc_env.merge(
      'rvm_path' => '/usr/local/rvm',
      'rvm_autolibs_flag' => new_resource.autolib_mode.to_s
    ))
  end

  # Add users to rvm group
  new_resource.rvm_group_users.each do |rvm_user|
    group 'rvm' do
      members rvm_user
      append true
      action :modify
    end
  end
end

action_class do
  include RvmCookbook::RvmHelper

  def rvm_installer_path
    ::File.join(Chef::Config[:file_cache_path], 'rvm_installer.sh')
  end

  def rvm_install_packages
    case node['platform_family']
    when 'rhel', 'fedora', 'amazon'
      # Don't install curl on RHEL - curl-minimal is already installed and conflicts
      %w(bash git tar bzip2 gzip)
    when 'debian'
      %w(bash curl git-core tar bzip2 gzip)
    else
      %w(bash curl git tar bzip2 gzip)
    end
  end

  def ruby_build_packages
    case node['platform_family']
    when 'rhel', 'fedora', 'amazon'
      %w(
        autoconf
        automake
        bison
        bzip2
        gcc-c++
        libffi-devel
        libtool
        readline-devel
        sqlite-devel
        zlib-devel
        libyaml-devel
        openssl-devel
      )
    when 'debian'
      %w(
        autoconf
        automake
        bison
        build-essential
        libffi-dev
        libreadline-dev
        libsqlite3-dev
        libssl-dev
        libyaml-dev
        zlib1g-dev
      )
    else
      []
    end
  end
end
