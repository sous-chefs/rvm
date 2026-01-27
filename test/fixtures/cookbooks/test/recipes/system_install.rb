# Update package lists on Debian-based systems
apt_update 'update' do
  action :update
  only_if { platform_family?('debian') }
end

# Install RVM to the system path e.g. /usr/local/rvm
rvm_system_install 'system'
