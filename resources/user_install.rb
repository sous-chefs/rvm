unified_mode true
provides :rvm_user_install

use '_partial/_user'
use '_partial/_gpg'
use '_partial/_rvm_install'

property :user,
         String,
         name_property: true,
         description: 'User to install RVM for'

property :home_dir,
         String,
         description: 'Home directory for the user (defaults to /home/<user>)'

action :install do
  user_home = new_resource.home_dir || user_home(new_resource.user)
  rvm_path = ::File.join(user_home, '.rvm')

  # Install dnf-plugins-core for config-manager command on RHEL 9+
  package 'dnf-plugins-core' do
    only_if do
      platform_family?('rhel') &&
        !platform?('fedora', 'amazon') &&
        node['platform_version'].to_i >= 9
    end
  end

  # Enable CRB repository on RHEL 9+ for development packages
  # CRB only exists on RHEL-based distros (not Fedora or Amazon Linux)
  execute 'enable_crb_repository' do
    command 'dnf config-manager --set-enabled crb'
    only_if do
      platform_family?('rhel') &&
        !platform?('fedora', 'amazon') &&
        node['platform_version'].to_i >= 9
    end
    not_if 'dnf repolist enabled | grep -q crb'
  end

  # Install Ruby build dependencies with cache flush to pick up CRB packages
  # Pre-installing these avoids RVM autolibs issues on EL9 distributions
  package ruby_build_packages do
    flush_cache({ before: true }) if platform_family?('rhel') && node['platform_version'].to_i >= 9
  end

  # Install GPG using the gpg cookbook
  gpg_install 'rvm'

  # Import RVM GPG keys for the user
  new_resource.gpg_key.split.each do |key_fingerprint|
    gpg_key "rvm_key_#{key_fingerprint}_#{new_resource.user}" do
      user new_resource.user
      keyserver new_resource.keyserver
      key_fingerprint key_fingerprint
      action :import
    end
  end

  # Download the RVM installer
  remote_file rvm_installer_path do
    source new_resource.installer_url
    mode '0755'
    action :create
  end

  # Install RVM for the user
  execute "install_rvm_user_#{new_resource.user}" do
    command "#{rvm_installer_path} #{new_resource.version}"
    user new_resource.user
    group Etc.getpwnam(new_resource.user).gid
    environment({
                  'HOME' => user_home,
                  'rvm_path' => rvm_path,
                  'DEBIAN_FRONTEND' => 'noninteractive',
                })
    creates ::File.join(rvm_path, 'bin', 'rvm')
  end

  # Create user rvmrc configuration
  template ::File.join(user_home, '.rvmrc') do
    source 'rvmrc.erb'
    cookbook 'rvm'
    owner new_resource.user
    group Etc.getpwnam(new_resource.user).gid
    mode '0644'
    variables(rvmrc_env: new_resource.rvmrc_env.merge(
      'rvm_path' => rvm_path,
      'rvm_autolibs_flag' => new_resource.autolib_mode.to_s
    ))
  end
end

action_class do
  include RvmCookbook::RvmHelper

  def rvm_installer_path
    ::File.join(Chef::Config[:file_cache_path], 'rvm_installer.sh')
  end

  def ruby_build_packages
    packages = case node['platform_family']
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
               when 'suse'
                 %w(
                   autoconf
                   automake
                   bison
                   gcc-c++
                   libffi-devel
                   libtool
                   readline-devel
                   sqlite3-devel
                   zlib-devel
                   libyaml-devel
                   libopenssl-devel
                 )
               else
                 []
               end
  end
end
