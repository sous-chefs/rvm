# Make sure that Vagrant user is on the box for dokken
include_recipe 'test::dokken'

# System Install
rvm_system_install 'system'

# Install several Rubies to a system wide location
rvm_ruby 'ruby-3.1.0'

rvm_ruby 'ruby-3.2.0' do
  default true
end

# Install a gem for a specific Ruby
rvm_gem 'mail' do
  version '2.8.1'
  ruby_string 'ruby-3.2.0'
end

rvm_gem 'mail' do
  version '2.8.1'
  ruby_string 'ruby-3.1.0'
end

rvm_gem 'mail' do
  ruby_string 'ruby-3.1.0'
  action :remove
end

# User Install
rvm_user_install 'vagrant'

# Install a Ruby to a user directory
rvm_ruby 'ruby-3.2.0' do
  user 'vagrant'
  default true
end

rvm_gem 'bundler' do
  user 'vagrant'
  ruby_string 'ruby-3.2.0'
end
