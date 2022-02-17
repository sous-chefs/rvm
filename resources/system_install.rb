unified_mode true
property :key_server, String, default: 'hkp://pool.sks-keyservers.net'
property :gpg_homedir, String, default: '~/.gnupg'
property :gpg_key, String, default: '409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB'

action :install do
  # Build the rvm group ahead of time, if it is set. This allows avoiding
  # collision with later processes which may set a guid explicitly
  if node['rvm']['group_id'] != 'default'
    g = group 'rvm' do
      group_name 'rvm'
      gid        node['rvm']['group_id']
      action     :nothing
    end
    g.run_action(:create)
  end

  key_server = new_resource.key_server
  home_dir = new_resource.gpg_homedir

  gpg_install

  execute 'Adding gpg key' do
    command "`which gpg2 || which gpg` --keyserver #{key_server} --homedir #{home_dir} --recv-keys #{new_resource.gpg_key}"
    only_if 'which gpg2 || which gpg'
  end

  rvm_installation('root')
end
