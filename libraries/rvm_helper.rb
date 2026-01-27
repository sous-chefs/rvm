module RvmCookbook
  module RvmHelper
    # Returns the RVM installation path for a user or system
    def rvm_path(user = nil)
      if user
        ::File.join(user_home(user), '.rvm')
      else
        '/usr/local/rvm'
      end
    end

    # Returns the home directory for a user
    def user_home(user)
      return unless user

      Etc.getpwnam(user).dir
    rescue ArgumentError
      "/home/#{user}"
    end

    # Returns the RVM binary path
    def rvm_bin(user = nil)
      ::File.join(rvm_path(user), 'bin', 'rvm')
    end

    # Returns the environment hash for running RVM commands
    def rvm_env(user = nil)
      env = { 'rvm_path' => rvm_path(user) }
      env['HOME'] = user_home(user) if user
      env
    end

    # Check if RVM is installed
    def rvm_installed?(user = nil)
      ::File.exist?(rvm_bin(user))
    end

    # Check if a Ruby version is installed
    def ruby_installed?(ruby_string, user = nil)
      return false unless rvm_installed?(user)

      cmd = shell_out("#{rvm_bin(user)} list strings", environment: rvm_env(user), user: user)
      cmd.exitstatus.zero? && cmd.stdout.include?(ruby_string)
    end

    # Get the default Ruby version
    def default_ruby(user = nil)
      return unless rvm_installed?(user)

      cmd = shell_out("#{rvm_bin(user)} alias show default", environment: rvm_env(user), user: user)
      cmd.exitstatus.zero? ? cmd.stdout.strip : nil
    end

    # Check if a gemset exists
    def gemset_exists?(ruby_string, gemset, user = nil)
      return false unless rvm_installed?(user)

      cmd = shell_out("#{rvm_bin(user)} #{ruby_string} do rvm gemset list", environment: rvm_env(user), user: user)
      cmd.exitstatus.zero? && cmd.stdout.include?(gemset)
    end

    # Check if an alias exists
    def alias_exists?(alias_name, user = nil)
      return false unless rvm_installed?(user)

      cmd = shell_out("#{rvm_bin(user)} alias show #{alias_name}", environment: rvm_env(user), user: user)
      cmd.exitstatus.zero? && !cmd.stdout.strip.empty?
    end

    # Get the target of an alias
    def alias_target(alias_name, user = nil)
      return unless alias_exists?(alias_name, user)

      cmd = shell_out("#{rvm_bin(user)} alias show #{alias_name}", environment: rvm_env(user), user: user)
      cmd.exitstatus.zero? ? cmd.stdout.strip : nil
    end

    # Check if a wrapper exists
    def wrapper_exists?(wrapper_prefix, binary, user = nil)
      wrapper_path = ::File.join(rvm_path(user), 'bin', "#{wrapper_prefix}_#{binary}")
      ::File.exist?(wrapper_path)
    end

    # Build RVM command with proper environment
    def rvm_command(cmd, user = nil)
      if user
        "bash -l -c 'source #{rvm_path(user)}/scripts/rvm && #{cmd}'"
      else
        "bash -l -c 'source /usr/local/rvm/scripts/rvm && #{cmd}'"
      end
    end
  end
end
