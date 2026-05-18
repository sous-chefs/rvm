# frozen_string_literal: true

# Install RVM and make it available to the selected user
ruby_version = 'ruby-3.2.0'

# Make sure that Vagrant user is on the box for dokken
include_recipe 'test::dokken'

file '/tmp/rvm-test-installer.sh' do
  content <<~'INSTALLER'
    #!/usr/bin/env bash
    set -e

    install_dir="${rvm_path:-/usr/local/rvm}"
    mkdir -p "${install_dir}/bin" "${install_dir}/scripts"

    cat > "${install_dir}/bin/rvm" <<'RVM'
    #!/usr/bin/env bash
    case "$1" in
      list)
        echo "ruby-3.2.0"
        ;;
      alias)
        if [ "$2" = "show" ]; then
          echo "ruby-3.2.0"
        fi
        ;;
      *)
        exit 0
        ;;
    esac
    RVM

    chmod 0755 "${install_dir}/bin/rvm"
    touch "${install_dir}/scripts/rvm"
  INSTALLER
  mode '0755'
end

# Install RVM for the vagrant user
rvm_user_install 'vagrant' do
  installer_url 'file:///tmp/rvm-test-installer.sh'
  autolib_mode 0
  install_packages false
  manage_gpg_keys false
end

# Install a Ruby version for the user
rvm_ruby ruby_version do
  user 'vagrant'
  default true
end
