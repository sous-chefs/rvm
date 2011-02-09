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
  return true if "goruby" == rubie        # gorubie has no versions yet
  return true if rubie =~ /^[^-]+-[^-]+/  # must be xxx-vvv at least
end

##
# Determines whether or not the given ruby is already installed
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby installed?
def ruby_installed?(rubie)
  return false unless ruby_string_sane?(rubie)

  installed = RVM.list_strings
  ! installed.select { |r| r.start_with?(rubie) }.empty?
end

##
# Determines whether or not the given ruby is a known ruby string
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby in the known ruby string list?
def ruby_known?(rubie)
  return false unless ruby_string_sane?(rubie)

  installed = RVM.list_known_strings
  ! installed.select { |r| r.start_with?(rubie) }.empty?
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
# Determines whether or not the given ruby is the default one
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby the default one?
def ruby_default?(rubie)
  return false unless ruby_string_sane?(rubie)

  current_default = RVM.list_default
  return false if current_default.nil?
  current_default.start_with?(rubie)
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

  env = RVM::Environment.new
  env.use opts[:ruby]
  env.gemset_list.include?(opts[:gemset])
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
# Installs any package dependencies needed by a given ruby
#
# @param [String, #to_s] the fully qualified RVM ruby string
def install_ruby_dependencies(rubie)
  pkgs = []
  if rubie =~ /^1\.[89]\../ || rubie =~ /^ree/ || rubie =~ /^ruby-/
    case node[:platform]
      when "centos","redhat","fedora","suse"
        pkgs = %w{ gcc-c++ patch readline readline-devel zlib zlib-devel
                   libyaml-devel libffi-devel openssl-devel } #iconv-devel }
        # TODO: Figure out the real state of iconv-devel and fixup the next few lines
        # NOTE: For centos 5.4 final iconv-devel might not be available :(
        #pkgs.delete('iconv-devel') if (node[:platform] == "centos" &&
        #                                !node[:platform_version] == '5.5')
        pkgs << %w{ git subversion autoconf } if rubie =~ /^ruby-head$/
      when "debian","ubuntu"
        pkgs = %w{ build-essential bison openssl libreadline6 libreadline6-dev
                   zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0
                   libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev ssl-cert }
        pkgs << %w{ git-core subversion autoconf } if rubie =~ /^ruby-head$/
    end
  elsif rubie =~ /^jruby/
    include_recipe "java"
    pkgs << "g++"
  end

  pkgs.each do |pkg|
    p = package pkg do
      action :nothing
    end
    p.run_action(:install)
  end
end
