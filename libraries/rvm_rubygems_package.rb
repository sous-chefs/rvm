#
# Cookbook Name:: rvm
# Provider:: Chef::Provider::Package::RVMRubygems
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

class Chef
  class Provider
    class Package
      class RVMRubygems < Chef::Provider::Package::Rubygems

        class RVMGemEnvironment < AlternateGemEnvironment
          attr_reader :ruby_string

          def initialize(gem_binary_location, ruby_string)
            super(gem_binary_location)
            @ruby_string = ruby_string
          end

          def gem_paths
            # shellout! is a fork/exec which won't work on windows
            shell_style_paths = shell_out!(rvm_wrap_cmd(
              "rvm #{ruby_string} exec #{@gem_binary_location} env gempath")).stdout
            # on windows, the path separator is semicolon
            paths = shell_style_paths.split(
              ::File::PATH_SEPARATOR).map { |path| path.strip }
          end

          def gem_platforms
            gem_environment = shell_out!(rvm_wrap_cmd(
              "rvm #{ruby_string} exec #{@gem_binary_location} env")).stdout
            if jruby = gem_environment[JRUBY_PLATFORM]
              ['ruby', Gem::Platform.new(jruby)]
            else
              Gem.platforms
            end
          end
        end

        def initialize(new_resource, run_context=nil)
          super
          @gem_env = RVMGemEnvironment.new(gem_binary_path, ruby_string)
        end

        def ruby_string
          @ruby_string ||= if new_resource.respond_to?("ruby_string")
            new_resource.ruby_string
          else
            node['rvm']['gem_package']['rvm_string']
          end
        end

        def install_package(name, version)
          ruby_string_normalized = normalize_ruby_string(ruby_string)

          # ensure ruby is installed and gemset exists
          e = rvm_environment ruby_string_normalized do
            action :nothing
          end
          e.run_action(:create)

          install_via_gem_command(name, version)
          true
        end

        def install_via_gem_command(name, version)
          src = @new_resource.source &&
            "  --source=#{@new_resource.source} --source=http://rubygems.org"

          cmd = %{rvm #{ruby_string} #{gem_binary_path}}
          cmd << %{ install #{name} -q --no-rdoc --no-ri -v "#{version}"}
          cmd << %{#{src}#{opts}}
          shell_out!(rvm_wrap_cmd(cmd), :env => nil)
        end

        def remove_package(name, version)
          uninstall_via_gem_command(name, version)
        end

        def uninstall_via_gem_command(name, version)
          cmd = %{rvm #{ruby_string} #{gem_binary_path}}
          cmd << %{ uninstall #{name} -q -x -I}
          if version
            cmd << %{ -v "#{version}"#{opts}}
          else
            cmd << %{ -a#{opts}}
          end
          shell_out!(cmd, :env=>nil)
        end
      end
    end
  end
end
