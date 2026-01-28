unified_mode true
provides :rvm_wrapper

use '_partial/_user'

property :prefix,
         String,
         name_property: true,
         description: 'Prefix for the wrapper script names'

property :ruby_string,
         String,
         required: true,
         description: 'Ruby version to create wrappers for'

property :binaries,
         Array,
         default: %w(ruby gem rake erb irb ri rdoc),
         description: 'List of binaries to create wrappers for'

default_action :create

action :create do
  new_resource.binaries.each do |binary|
    execute "rvm_wrapper_#{new_resource.prefix}_#{binary}" do
      command "#{rvm_bin(new_resource.user)} wrapper #{new_resource.ruby_string} #{new_resource.prefix} #{binary}"
      environment rvm_env(new_resource.user)
      user new_resource.user if new_resource.user
      creates wrapper_path(binary)
    end
  end
end

action_class do
  include RvmCookbook::RvmHelper

  def wrapper_path(binary)
    ::File.join(rvm_path(new_resource.user), 'bin', "#{new_resource.prefix}_#{binary}")
  end
end
