unified_mode true

include_recipe 'rvm::system_install'

perform_install_rubies = node['rvm']['install_rubies'] == true ||
                         node['rvm']['install_rubies'] == 'true'

if perform_install_rubies
  install_rubies  rubies: node['rvm']['rubies'],
                  default_ruby: node['rvm']['default_ruby'],
                  global_gems: node['rvm']['global_gems'],
                  gems: node['rvm']['gems']
end

# add users to rvm group
group 'rvm' do
  members node['rvm']['group_users']

  only_if { node['rvm']['group_users'].any? }
end
