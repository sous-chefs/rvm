# Install RVM and make it available to the selected user
ruby_version = 'ruby-3.2.0'

# Update package lists on Debian-based systems
apt_update 'update' do
  action :update
  only_if { platform_family?('debian') }
end

# Disable epel-next on EL10 before EPEL installation
# The yum-epel cookbook creates epel-next repo but mirrorlist doesn't exist yet (404 errors)
node.override['yum']['epel-next']['enabled'] = false if platform_family?('rhel') && node['platform_version'].to_i >= 10

# Make sure that Vagrant user is on the box for dokken
include_recipe 'test::dokken'

# Install RVM for the vagrant user
# Build dependencies are installed automatically by the resource
rvm_user_install 'vagrant' do
  autolib_mode 0
end

# Install a Ruby version for the user
rvm_ruby ruby_version do
  user 'vagrant'
  default true
end
