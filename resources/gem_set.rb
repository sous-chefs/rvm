unified_mode true
provides :rvm_gemset

use '_partial/_user'

property :gemset,
         String,
         name_property: true,
         description: 'Name of the gemset to manage'

property :ruby_string,
         String,
         required: true,
         description: 'Ruby version for the gemset'

default_action :create

action :create do
  execute "rvm_gemset_create_#{new_resource.gemset}" do
    command "#{rvm_bin(new_resource.user)} #{new_resource.ruby_string} do rvm gemset create #{new_resource.gemset}"
    environment rvm_env(new_resource.user)
    user new_resource.user if new_resource.user
    not_if { gemset_exists?(new_resource.ruby_string, new_resource.gemset, new_resource.user) }
  end
end

action :delete do
  execute "rvm_gemset_delete_#{new_resource.gemset}" do
    command "#{rvm_bin(new_resource.user)} #{new_resource.ruby_string} do rvm gemset delete #{new_resource.gemset} --force"
    environment rvm_env(new_resource.user)
    user new_resource.user if new_resource.user
    only_if { gemset_exists?(new_resource.ruby_string, new_resource.gemset, new_resource.user) }
  end
end

action :empty do
  execute "rvm_gemset_empty_#{new_resource.gemset}" do
    command "#{rvm_bin(new_resource.user)} #{new_resource.ruby_string}@#{new_resource.gemset} do rvm gemset empty --force"
    environment rvm_env(new_resource.user)
    user new_resource.user if new_resource.user
    only_if { gemset_exists?(new_resource.ruby_string, new_resource.gemset, new_resource.user) }
  end
end

action_class do
  include RvmCookbook::RvmHelper
end
