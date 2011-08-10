#
# Cookbook Name:: rvm
# Library:: helpers
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

begin
  require 'rvm'
rescue LoadError
  Chef::Log.debug("Missing gem 'rvm' (#{File.basename(__FILE__)})")
end

class Chef
  module RVM
    module StringHelpers
      ##
      # Filters out any gemset declarations in an RVM ruby string
      #
      # @param [String, #to_s] the fully qualified RVM ruby string
      # @return [String] the ruby string, minus gemset
      def select_ruby(ruby_string)
        ruby_string.split('@').first
      end

      ##
      # Filters out any ruby declaration in an RVM ruby string
      #
      # @param [String, #to_s] the fully qualified RVM ruby string
      # @return [String] the gemset string, minus ruby or nil if no gemset given
      def select_gemset(ruby_string)
        if ruby_string.include?('@')
          ruby_string.split('@').last
        else
          nil
        end
      end

      ##
      # Sanitizes a ruby string so that it's more normalized.
      #
      # @param [String, #to_s] an RVM ruby string
      # @return [String] a fully qualified RVM ruby string
      def normalize_ruby_string(ruby_string)
        return "system" if ruby_string == "system"
        StringCache.fetch(ruby_string, new_resource.user)
      end
    end

    module RubyHelpers
      ##
      # Lists all installed RVM rubies on the system.
      #
      # **Note** that these values are cached for lookup speed. To flush these
      # values and force an update, call #update_installed_rubies.
      #
      # @return [Array] the cached list of currently installed rvm rubies
      def installed_rubies
        @installed_rubies ||= update_installed_rubies
      end

      ##
      # Updates the list of all installed RVM rubies on the system
      #
      # @return [Array] the list of currently installed rvm rubies
      def update_installed_rubies
        @installed_rubies = @rvm_env.list_strings
        @installed_rubies
      end

      ##
      # Determines whether or not the given ruby is already installed
      #
      # @param [String, #to_s] the fully qualified RVM ruby string
      # @return [Boolean] is this ruby installed?
      def ruby_installed?(rubie)
        ! installed_rubies.select { |r| r.start_with?(rubie) }.empty?
      end

      ##
      # Fetches the current default ruby string, potentially with gemset
      #
      # @return [String] the fully qualified RVM ruby string, nil if none is set
      def current_ruby_default
        @rvm_env.list_default
      end

      ##
      # Determines whether or not the given ruby is the default one
      #
      # @param [String, #to_s] the fully qualified RVM ruby string
      # @return [Boolean] is this ruby the default one?
      def ruby_default?(rubie)
        current_default = current_ruby_default

        if current_default.nil?
          if rubie == "system"
            return true
          else
            return false
          end
        end

        current_default.start_with?(rubie)
      end

      ##
      # Determines whether or not the given ruby could be considered the system
      # ruby.
      #
      # @param [String, #to_s] an RVM ruby string
      # @return [Boolean] is this ruby string the a system ruby?
      def system_ruby?(rubie)
        return true if rubie.nil?         # nil should be system
        return true if rubie.empty?       # an empty string should be system
        return true if rubie == "system"  # keyword system should be system
        return false                      # anything else does not represent system
      end
    end

    module GemsetHelpers
      ##
      # Lists all gemsets for a given RVM ruby.
      #
      # **Note** that these values are cached for lookup speed. To flush these
      # values and force an update, call #update_installed_gemsets.
      #
      # @param [String, #to_s] the fully qualified RVM ruby string
      # @return [Array] a cached list of gemset names
      def installed_gemsets(rubie)
        @installed_gemsets = Hash.new if @installed_gemsets.nil?
        @installed_gemsets[rubie] ||= update_installed_gemsets(rubie)
      end

      ##
      # Updates the list of all gemsets for a given RVM ruby on the system
      #
      # @param [String, #to_s] the fully qualified RVM ruby string
      # @return [Array] the current list of gemsets
      def update_installed_gemsets(rubie)
        original_rubie = @rvm_env.environment_name
        @rvm_env.use rubie

        @installed_gemsets ||= {}
        @installed_gemsets[rubie] = @rvm_env.gemset_list
        @rvm_env.use original_rubie if original_rubie != rubie
        @installed_gemsets[rubie]
      end

      ##
      # Determines whether or not a gemset exists for a given ruby
      #
      # @param [Hash] the options to query a gemset with
      # @option opts [String] :ruby the ruby the query within
      # @option opts [String] :gemset the gemset to look for
      def gemset_exists?(opts={})
        return false if opts[:ruby].nil? || opts[:gemset].nil?
        return false unless ruby_installed?(opts[:ruby])

        installed_gemsets(opts[:ruby]).include?(opts[:gemset])
      end
    end

    module EnvironmentHelpers
      include RubyHelpers
      include GemsetHelpers

      ##
      # Determines whether or not and ruby/gemset environment exists
      #
      # @param [String, #to_s] the fully qualified RVM ruby string
      # @return [Boolean] does this environment exist?
      def env_exists?(ruby_string)
        return true if system_ruby?(ruby_string)

        rubie   = select_ruby(ruby_string)
        gemset  = select_gemset(ruby_string)

        if gemset
          gemset_exists?(:ruby => rubie, :gemset => gemset)
        else
          ruby_installed?(rubie)
        end
      end
    end

    module ShellHelpers
      # Please see libraries/rvm_rubygems_package.rb. There is a dependency
      # in Chef::Provider::Package::RVMRubygems and library load order cannot
      # be guarenteed.
    end

    module RecipeHelpers
      def build_script_flags(version, branch)
        script_flags = ""
        script_flags += " --version #{version}" if version
        script_flags += " --branch #{branch}"   if branch
      end

      def build_upgrade_strategy(strategy)
        if strategy.nil? || strategy == false
          "none"
        else
          strategy
        end
      end

      def install_pkg_prereqs(install_now = node.recipe?("rvm::gem_package"))
        node['rvm']['install_pkgs'].each do |pkg|
          p = package pkg do
            # excute in compile phase if gem_package recipe is requested
            if install_now
              action :nothing
            else
              action :install
            end
          end
          p.run_action(:install) if install_now
        end
      end

      def install_rvm(opts = {})
        install_now = node.recipe?("rvm::gem_package")

        if opts[:user]
          user_dir    = opts[:rvm_prefix]
          exec_name   = "install user RVM for #{opts[:user]}"
          exec_env    = { 'USER' => opts[:user], 'HOME' => user_dir }
        else
          user_dir    = nil
          exec_name   = "install system-wide RVM"
          exec_env    = nil
        end

        i = execute exec_name do
          user    opts[:user] || "root"
          command <<-CODE
            bash -c "bash \
              <( curl -Ls #{opts[:installer_url]} )#{opts[:script_flags]}"
          CODE
          environment(exec_env)

          # excute in compile phase if gem_package recipe is requested
          if install_now
            action :nothing
          else
            action :run
          end

          not_if  rvm_wrap_cmd(
            %{type rvm | head -1 | grep -q '^rvm is a function$'}, user_dir)
        end
        i.run_action(:run) if install_now
      end

      def upgrade_rvm(opts = {})
        install_now = node.recipe?("rvm::gem_package")

        if opts[:user]
          user_dir    = opts[:rvm_prefix]
          exec_name   = "upgrade user RVM for #{opts[:user]} to " +
                        opts[:upgrade_strategy]
          exec_env    = { 'USER' => opts[:user], 'HOME' => user_dir }
        else
          user_dir    = nil
          exec_name   = "upgrade system-wide RVM to " +
                        opts[:upgrade_strategy]
          exec_env    = nil
        end

        u = execute exec_name do
          user      opts[:user] || "root"
          command   rvm_wrap_cmd(%{rvm get #{opts[:upgrade_strategy]}}, user_dir)
          environment(exec_env)

          # excute in compile phase if gem_package recipe is requested
          if install_now
            action :nothing
          else
            action :run
          end

          only_if   { %w{ latest head }.include?(opts[:upgrade_strategy]) }
        end
        u.run_action(:run) if install_now
      end

      def rvmrc_template(opts = {})
        install_now = node.recipe?("rvm::gem_package")

        if opts[:user]
          system_install  = false
          rvmrc_file      = "#{opts[:rvm_prefix]}/.rvmrc"
          rvm_path        = "#{opts[:rvm_prefix]}/.rvm"
        else
          system_install  = true
          rvmrc_file      = "/etc/rvmrc"
          rvm_path        = "#{opts[:rvm_prefix]}/rvm"
        end

        t = template rvmrc_file do
          source      "rvmrc.erb"
          owner       opts[:user] || "root"
          group       opts[:user] if opts[:user]
          mode        "0644"
          variables   :system_install   => system_install,
                      :rvm_path         => rvm_path,
                      :rvm_gem_options  => opts[:rvm_gem_options],
                      :rvmrc            => opts[:rvmrc]

          # excute in compile phase if gem_package recipe is requested
          if install_now
            action :nothing
          else
            action :create
          end
        end
        t.run_action(:create) if install_now
      end

      def install_rubies(opts = {})
        # install additional rubies
        opts[:rubies].each do |rubie|
          rvm_ruby rubie do
            user  opts[:user]
          end
        end

        # set a default ruby
        rvm_default_ruby opts[:default_ruby] do
          user  opts[:user]
        end

        # install global gems
        opts[:global_gems].each do |gem|
          rvm_global_gem gem[:name] do
            user      opts[:user]
            [:version, :action, :options, :source].each do |attr|
              send(attr, gem[attr]) if gem[attr]
            end
          end
        end

        # install additional gems
        opts[:gems].each_pair do |rstring, gems|
          rvm_environment rstring do
            user  opts[:user]
          end

          gems.each do |gem|
            rvm_gem gem[:name] do
              ruby_string   rstring
              user          opts[:user]
              [:version, :action, :options, :source].each do |attr|
                send(attr, gem[attr]) if gem[attr]
              end
            end
          end
        end
      end
    end
  end
end
