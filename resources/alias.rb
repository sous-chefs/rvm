unified_mode true
provides :rvm_alias

use '_partial/_user'

property :alias_name,
         String,
         name_property: true,
         description: 'Name of the alias to manage'

property :ruby_string,
         String,
         required: true,
         description: 'Ruby version the alias points to'

default_action :create

action :create do
  execute "rvm_alias_create_#{new_resource.alias_name}" do
    command "#{rvm_bin(new_resource.user)} alias create #{new_resource.alias_name} #{new_resource.ruby_string}"
    environment rvm_env(new_resource.user)
    user new_resource.user if new_resource.user
    not_if { alias_target(new_resource.alias_name, new_resource.user) == new_resource.ruby_string }
  end
end

action :delete do
  execute "rvm_alias_delete_#{new_resource.alias_name}" do
    command "#{rvm_bin(new_resource.user)} alias delete #{new_resource.alias_name}"
    environment rvm_env(new_resource.user)
    user new_resource.user if new_resource.user
    only_if { alias_exists?(new_resource.alias_name, new_resource.user) }
  end
end

action_class do
  include RvmCookbook::RvmHelper
end
