#
# Cookbook Name:: rvm
# Library:: ruby
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

  RVM.list_default.start_with?(rubie)
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
