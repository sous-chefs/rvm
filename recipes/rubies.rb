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

%w{build-essential bison openssl libreadline6 libreadline6-dev 
    zlib1g zlib1g-dev libssl-dev vim libsqlite3-0 libsqlite3-dev sqlite3 
    libxml2-dev subversion autoconf ssl-cert}.each do |pkg|
  package pkg
end

node[:rvm][:rubies].each do |ruby|
  bash "install #{ruby}" do
    user "root"
    code "rvm install #{ruby}"
    not_if %{rvm list strings | grep -q "#{ruby}" >/dev/null}
  end
end
