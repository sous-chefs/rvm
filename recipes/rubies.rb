#
# Cookbook Name:: rvm
# Recipe:: rubies
#
# Copyright 2010, Fletcher Nichol
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

# thanks to:
# - http://www.agileweboperations.com/chef-rvm-ruby-enterprise-edition-as-default-ruby/
# - http://github.com/denimboy/xprdev/blob/master/rvm/recipes/ree.rb


node[:rvm][:rubies].each do |ruby|
  pkgs = []
  if ruby =~ /^1\.[89]\../ || ruby =~ /^ree/ || ruby =~ /^ruby-/
    case node[:platform]
      when "centos","redhat","fedora","suse"
        pkgs = %w{ gcc-c++ patch readline readline-devel zlib zlib-devel 
                   libyaml-devel libffi-devel openssl-devel } #iconv-devel }
        # TODO: Figure out the real state of iconv-devel and fixup the next few lines
        # NOTE: For centos 5.4 final iconv-devel might not be available :(
        #pkgs.delete('iconv-devel') if (node[:platform] == "centos" && 
        #                                !node[:platform_version] == '5.5')
        pkgs << %w{git subversion autoconf} if ruby =~ /^ruby-head$/
      when "debian","ubuntu"
        pkgs = %w{ build-essential bison openssl libreadline6 libreadline6-dev
                   zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 
                   libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev ssl-cert }
        pkgs << %w{git-core subversion autoconf} if ruby =~ /^ruby-head$/
    end
  elsif ruby =~ /^jruby/
    include_recipe "java"
  end

  pkgs.each do |pkg|
    package pkg
  end

  bash "install RVM ruby: #{ruby}" do
    user "root"
    code %{source /etc/profile.d/rvm.sh && rvm install #{ruby}}
    not_if %{bash -c "source /etc/profile.d/rvm.sh && rvm list strings | grep -q '^#{ruby}' >/dev/null"}
  end
end

