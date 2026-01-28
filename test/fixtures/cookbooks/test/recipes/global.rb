global_version = 'ruby-3.2.0'

# Install RVM Globally
rvm_system_install 'system'

rvm_ruby global_version do
  default true
end

# Make sure that Vagrant user is on the box for dokken
include_recipe 'test::dokken'
