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
  Chef::Log.warn("Missing gem 'rvm'")
end

##
# Determines if given ruby string is moderatley sane and potentially legal
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby string sane?
def ruby_string_sane?(rubie)
  return true if ['goruby', 'ree', 'kiji'].include?(rubie) # rubies with aliases
  return true if rubie =~ /^[^-]+-[^-]+/  # must be xxx-vvv at least
end

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
  @installed_rubies = RVM.list_strings
  @installed_rubies
end

##
# Determines whether or not the given ruby is already installed
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby installed?
def ruby_installed?(rubie)
  return false unless ruby_string_sane?(rubie)

  ! installed_rubies.select { |r| r.start_with?(rubie) }.empty?
end

##
# Inverse of #ruby_installed?
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby not installed?
def ruby_not_installed?(rubie)
  !ruby_installed?(rubie)
end

##
# Determines whether or not the given ruby is a known ruby string
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby in the known ruby string list?
def ruby_known?(rubie)
  return true if rubie == 'system'
  return false unless ruby_string_sane?(rubie)

  matches = known_rubies.select { |r| r.start_with?(rubie) }
  if matches.empty?
    # last-ditch attempt at matching. we'll drop the last -.*$ bit off the
    # string assuming that the rubie contains a non-default patchlevel that
    # will actually exist
    fuzzier_rubie = rubie.sub(/-[^-]+$/, '')
    return ! known_rubies.select { |r| r.start_with?(fuzzier_rubie) }.empty?
  else
    return true
  end
end

##
# List all known RVM ruby strings.
#
# **Note** that these values are cached for lookup speed. To flush these
# values and force an update, call #update_known_rubies.
#
# @return [Array] the cached list of known ruby strings
def known_rubies
  @known_rubies ||= update_known_rubies
end

##
# Updates the list of all known RVM strings.
#
# @return [Array] the list of known ruby strings
def update_known_rubies
  @known_rubies = RVM.list_known_strings
  @known_rubies
end

##
# Inverse of #ruby_known?
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby an unknown ruby string?
def ruby_unknown?(rubie)
  !ruby_known?(rubie)
end

##
# Fetches the current default ruby string, potentially with gemset
#
# @return [String] the fully qualified RVM ruby string, nil if none is set
def current_ruby_default
  RVM.list_default
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

  return false unless ruby_string_sane?(rubie)
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
  env = RVM::Environment.new
  env.use rubie

  @installed_gemsets ||= {}
  @installed_gemsets[rubie] = env.gemset_list
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
  return false unless ruby_string_sane?(opts[:ruby])
  return false unless ruby_installed?(opts[:ruby])

  installed_gemsets(opts[:ruby]).include?(opts[:gemset])
end

##
# Determines whether or not there is a gemset defined in a given ruby string
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] does the ruby string appear to have a gemset included?
def string_include_gemset?(ruby_string)
  ruby_string.include?('@')
end

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
  if string_include_gemset?(ruby_string)
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
  # get the actual ruby string that corresponds to "default"
  if ruby_string.start_with?("default")
    ruby_string.sub(/default/, current_ruby_default)
  else
    ruby_string
  end
end

##
# Finds the correct shell profile to source to init an RVM-aware
# shell environment
#
# @return [String] full path the shell profile
def find_profile_to_source
  if ::File.directory?("/etc/profile.d")
    "/etc/profile.d/rvm.sh"
  else
    "/etc/profile"
  end
end

##
# Returns a shell command that is RVM-aware
#
# @param [String, #to_s] the shell command to be wrapped
# @return [String] the command wrapped in RVM-initialized bash command
def rvm_wrap_cmd(cmd)
  %{bash -c "source #{find_profile_to_source} && #{cmd.gsub(/"/, '\"')}"}
end

##
# Installs any package dependencies needed by a given ruby
#
# @param [String, #to_s] the fully qualified RVM ruby string
def install_ruby_dependencies(rubie)
  pkgs = []
  if rubie =~ /^1\.[89]\../ || rubie =~ /^ree/ || rubie =~ /^ruby-/
    case node[:platform]
      when "debian","ubuntu"
        pkgs = %w{ build-essential bison openssl libreadline6 libreadline6-dev
                   zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0
                   libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev ssl-cert }
        pkgs += %w{ git-core subversion autoconf } if rubie =~ /^ruby-head$/
      when "suse"
        pkgs = %w{ gcc-c++ patch zlib zlib-devel libffi-devel
                   sqlite3-devel libxml2-devel libxslt-devel }
        if node.platform_version.to_f >= 11.0
          pkgs += %w{ libreadline5 readline-devel libopenssl-devel }
        else
          pkgs += %w{ readline readline-devel openssl-devel }
        end
        pkgs += %w{ git subversion autoconf } if rubie =~ /^ruby-head$/
      when "centos","redhat","fedora"
        pkgs = %w{ gcc-c++ patch readline readline-devel zlib zlib-devel
                   libyaml-devel libffi-devel openssl-devel }
        pkgs += %w{ git subversion autoconf } if rubie =~ /^ruby-head$/
    end
  elsif rubie =~ /^jruby/
    # TODO: need to figure out how to pull in java recipe only when needed. For
    # now, users of jruby will have to add the "java" recipe to their run_list.
    #include_recipe "java"
    pkgs << "g++"
  end

  pkgs.each do |pkg|
    p = package pkg do
      action :nothing
    end
    p.run_action(:install)
  end
end
