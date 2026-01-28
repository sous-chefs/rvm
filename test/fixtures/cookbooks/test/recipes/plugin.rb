ruby_version = 'ruby-3.2.0'

# Make sure that Vagrant user is on the box for dokken
include_recipe 'test::dokken'

# Install RVM for user
rvm_user_install 'vagrant'

# Install RVM system-wide
rvm_system_install 'system'

# Install Ruby for user
rvm_ruby ruby_version do
  user 'vagrant'
  default true
end

# Create a wrapper for the user's Ruby
rvm_wrapper 'vagrant_ruby' do
  ruby_string ruby_version
  user 'vagrant'
  binaries %w(ruby gem rake bundle)
end
