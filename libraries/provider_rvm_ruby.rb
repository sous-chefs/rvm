require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class RvmRuby < Chef::Provider::LWRPBase
      provides :rvm_ruby if defined?(provides)

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :install do
        remote_file 'rvm_installer' do
          path "#{Chef::Config[:file_cache_path]}/rvm_installer.sh"
          source node['rvm']['installer_url']
          mode 0755
          not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/rvm_installer.sh") }
          action :create
        end
      end
    end
  end
end
