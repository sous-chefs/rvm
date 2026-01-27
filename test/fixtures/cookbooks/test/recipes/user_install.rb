# Install RVM and make it available to the selected user
ruby_version = 'ruby-3.2.0'

# Make sure that Vagrant user is on the box for dokken
include_recipe 'test::dokken'

# Install RVM for the vagrant user
rvm_user_install 'vagrant'

# Install a Ruby version for the user
rvm_ruby ruby_version do
  user 'vagrant'
  default true
end
