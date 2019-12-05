require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class RvmRuby < Chef::Resource::LWRPBase
      provides :rvm_ruby

      self.resource_name = :rvm_ruby
      default_action :install
    end
  end
end
