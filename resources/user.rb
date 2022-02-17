unified_mode true

action :install do
  include_recipe 'rvm::user_install'

  Array(node['rvm']['user_installs']).each do |rvm_user|
    perform_install_rubies  = rvm_user['install_rubies'] == true ||
                              rvm_user['install_rubies'] == 'true' ||
                              node['rvm']['user_install_rubies'] == true ||
                              node['rvm']['user_install_rubies'] == 'true'
    rubies                  = rvm_user['rubies'] ||
                              node['rvm']['user_rubies']
    default_ruby            = rvm_user['default_ruby'] ||
                              node['rvm']['user_default_ruby']
    global_gems             = rvm_user['global_gems'] ||
                              node['rvm']['user_global_gems']
    gems                    = rvm_user['gems'] ||
                              node['rvm']['user_gems']

    next unless perform_install_rubies
    install_rubies  rubies: rubies,
                    default_ruby: default_ruby,
                    global_gems: global_gems,
                    gems: gems,
                    user: rvm_user['user']
  end
end
