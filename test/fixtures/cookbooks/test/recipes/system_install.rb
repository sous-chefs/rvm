# Update package lists on Debian-based systems
apt_update 'update' do
  action :update
  only_if { platform_family?('debian') }
end

# Disable epel-next on EL10 before EPEL installation
# The yum-epel cookbook creates epel-next repo but mirrorlist doesn't exist yet (404 errors)
node.override['yum']['epel-next']['enabled'] = false if platform_family?('rhel') && node['platform_version'].to_i >= 10

# Install RVM to the system path e.g. /usr/local/rvm
rvm_system_install 'system'
