require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class RvmRuby < Chef::Provider::LWRPBase
      provides :rvm_ruby

      action :install do
        remote_file 'rvm_installer' do
          path "#{Chef::Config[:file_cache_path]}/rvm_installer.sh"
          source node['rvm']['installer_url']
          mode '755'
          action :create_if_missing
        end
      end
    end
  end
end
