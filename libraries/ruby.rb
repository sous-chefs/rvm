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
# Determines whether or not the given ruby is already installed
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby installed?
def ruby_installed?(rubie)
  RVM.list_strings.include?(rubie)
end

##
# Determines whether or not the given ruby is a known ruby string
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby in the known ruby string list?
def ruby_known?(rubie)
  RVM.list_known_strings.include?(rubie)
end

##
# Inverse of #ruby_known?
#
# @param [String, #to_s] the fully qualified RVM ruby string
# @return [Boolean] is this ruby an unknown ruby string?
def ruby_unknown?(rubie)
  !ruby_known?(rubie)
end
