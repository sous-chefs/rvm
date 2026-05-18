# frozen_string_literal: true

ruby_version = 'ruby-3.1.0'

# Make sure that Vagrant user is on the box for dokken
include_recipe 'test::dokken'

# System Install
rvm_system_install 'system'

# Install system wide Ruby
rvm_ruby ruby_version

# Set as default
rvm_ruby 'ruby-3.2.0' do
  default true
end

# Uninstall the first Ruby
rvm_ruby ruby_version do
  action :uninstall
end
