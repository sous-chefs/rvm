unified_mode true

action :install do
  node_val = node['rvm']['gem_package']['rvm_string']
  case node_val
  when String
    rvm_descriptor = node_val + ' RVM Ruby'
  when Array
    last = node_val.pop
    rvm_descriptor = [ node_val.join(', '), last ].join(' & ') + ' RVM Rubies'
  end

  patch_gem_package

  ::Chef::Log.info 'gem_package resource has been patched to use provider ' \
                  'Chef::Provider::Package::RVMRubygems and will install gems to ' \
                  "the #{rvm_descriptor}."
end
