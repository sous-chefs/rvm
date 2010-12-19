#
# Cookbook Name:: rvm
# Recipe:: gems
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

node[:rvm][:gems].each_pair do |ruby_gemset, gems|
  gems.each do |gem|
    rvm_gem gem[:name] do
      ruby      ruby_gemset
      version   gem[:version] if gem[:version]
      action    gem[:action] if gem[:action]
      options   gem[:options] if gem[:options]
      source    gem[:source] if gem[:source]
    end
  end
end
