#
# Cookbook Name:: rvm
# Attributes:: user_install
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2016, 2017, Fletcher Nichol
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

# the atribute file contents in readme gave error hence contributing code that is tested on Amazon linux , Ubuntu 16.04.
# invoke per user rvm install by adding the recipe rvm::user in your run list
# No need to add rvm::default to runlist in case you don't need to change the system ruby  
# rvm ruby that will be used for user_installs resources
# Important : The recipe assumes that the users mentioned below should already be created on the system and should have a /home/user-dir

#node.default['rvm']['user_installs'] = [
#  	{ 'user'          => 'userfoo1',
#   'default_ruby'  => '2.1.6',
#		'rubies'       => ['1.9.2', '1.9.3']
#  	},
#
#		{ 'user'          => 'userfoo2',
#    'default_ruby'  => '2.1.6',
#    'rubies'        => ['1.9.3']
#		}
#
#]