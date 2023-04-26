unified_mode true

property :installer_url, String, default: lazy { node['rvm']['installer_url'] }

action :install do
  remote_file 'rvm_installer' do
    path "#{Chef::Config[:file_cache_path]}/rvm_installer.sh"
    source new_resource.installer_url
    mode '755'
    action :create_if_missing
  end
end
