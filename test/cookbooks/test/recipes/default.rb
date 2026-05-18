# frozen_string_literal: true

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

rvm_system_install 'system' do
  installer_url 'file:///tmp/rvm-test-installer.sh'
  install_packages false
  manage_gpg_keys false
end
