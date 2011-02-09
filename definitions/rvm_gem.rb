#
# Cookbook Name:: ruby_enterprise
# Based on ruby_enterprise (ree_gem).
# Recipe:: rvm_gem
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright 2009, Opscode, Inc.
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

define :rvm_gem, :ruby => "default", :source => nil, :version => nil ,
    :options => nil, :action => :install do
  gem_package params[:name] do
    gem_binary  "rvm #{params[:ruby]} gem"
    action      params[:action]
    source      params[:source] if params[:source]
    options     params[:options] if params[:options]
    version     params[:version] if params[:version]
  end
end

