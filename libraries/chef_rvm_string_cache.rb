#
# Cookbook Name:: rvm
# Library:: Chef::RVM::StringCache
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

require 'chef/mixin/command'

class Chef
  module RVM
    class StringCache
      class << self
        include Chef::Mixin::Command
      end

      def self.[](str)
        @@strings ||= Hash.new
        return @@strings[str] if @@strings.has_key?(str)
        @@strings[str] = canonical_ruby_string(str)
      end

      protected

      def self.canonical_ruby_string(str)
        Chef::Log.debug("Fetching canonical RVM string for: #{str}")
        cmd = ["source #{find_profile_to_source}", "rvm_ruby_string='#{str}'",
          "__rvm_ruby_string", "echo $rvm_ruby_string"].join(" && ")
        pid, stdin, stdout, stderr = popen4('bash')
        stdin.puts(cmd)
        stdin.close

        result = stdout.read.split('\n').first.chomp
        if result =~ /^-/   # if the result has a leading dash, value is bogus
          nil
        else
          result
        end
      end
    end
  end
end
