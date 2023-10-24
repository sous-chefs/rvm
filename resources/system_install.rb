unified_mode true
property :key_server, String, default: 'hkp://pool.sks-keyservers.net'
property :gpg_homedir, String, default: '~/.gnupg'
property :gpg_key, String, default: '409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB'

action :install do
  group 'rvm'

  gpg_install

  execute 'Adding gpg key' do
    command "`which gpg2 || which gpg` --keyserver #{new_resource.key_server} --homedir #{new_resource.gpg_homedir} --recv-keys #{new_resource.gpg_key}"
    only_if 'which gpg2 || which gpg'
  end

  rvm_installation('root')
end
