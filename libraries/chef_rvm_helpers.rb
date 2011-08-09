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
        StringCache[ruby_string]
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
  end
end
