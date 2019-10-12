require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class RvmRuby < Chef::Provider::LWRPBase
      provides :rvm_ruby if defined?(provides)

      action :install do
        remote_file 'rvm_installer' do
          path "#{Chef::Config[:file_cache_path]}/rvm_installer.sh"
          source node['rvm']['installer_url']
          mode '755'
          not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/rvm_installer.sh") }
          action :create
        end
      end
    end
  end
end
