# Install RVM and make it available to the selected user
ruby_version = 'ruby-3.2.0'

# Update package lists on Debian-based systems
apt_update 'update' do
  action :update
  only_if { platform_family?('debian') }
end

# Make sure that Vagrant user is on the box for dokken
include_recipe 'test::dokken'

# Pre-install Ruby build dependencies to avoid RVM autolibs issues
# RVM's autolibs has known issues on EL9 distributions
case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  package %w(
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
  package %w(
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
end

# Install RVM for the vagrant user with autolibs disabled
# since we're pre-installing dependencies
rvm_user_install 'vagrant' do
  autolib_mode 0
end

# Install a Ruby version for the user
rvm_ruby ruby_version do
  user 'vagrant'
  default true
end
