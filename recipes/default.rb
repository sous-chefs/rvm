#
# Cookbook Name:: rvm
# Recipe:: default
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
# - http://github.com/denimboy/xprdev/blob/master/rvm/recipes/default.rb

%w{sed grep tar gzip bzip2 bash curl git-core}.each do |pkg|
  package pkg
end

bash "install system-wide RVM" do
  user "root"
  code %{bash < <( curl -L http://bit.ly/rvm-install-system-wide )}
  not_if %{bash -c "source /etc/profile.d/rvm.sh && rvm --version"}
end

cookbook_file "/etc/profile.d/rvm.sh"
