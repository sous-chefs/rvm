# DESCRIPTION

Installs a system-wide RVM and manages installed rubies.

# REQUIREMENTS

## Platform

For the moment this is targeted at Ubuntu, other platforms to be tested.

## Cookbooks

TBD

# ATTRIBUTES:

## `default_ruby`

The default ruby for RVM. If the RVM ruby is not installed, it will be
built as a pre-requisite. The value can also contain a gemset in the form of
`ruby-1.8.7-p330@awesome`.

**Note:** a fully qualified RVM string name needs to be used, which can be
found when running `rvm list known`.

The default is `ruby-1.9.2-p136`.

## `rubies`

A list of RVM rubies to be built and installed. If this list is emptied then
no rubies (not even the default) will be built and installed, like so:

    node[:rvm][:rubies] = []

**Note:** a fully qualified RVM string name needs to be used, which can be
found when running `rvm list known`.

The default is the value of `node[:rvm][:default_ruby]`.

## `global_gems`

A list of gem hashes to be installed into the *global* gemset in each
installed RVM ruby. The RVM global.gems files will be added to and all
installed rubies will be iterated over to ensure full installation coverage.
See the `rvm_gem` resource for more details about the options for each
gem hash. The default puts bundler in each ruby:

    node[:rvm][:global_gems] = [
      { :name => "bundler" }
    ]

## `gems`

A list of gem hashes to be installed into arbitrary RVM rubies and gemsets.
See the `rvm_gem` resource for more details about the options for each gem
hash and target ruby environment. The default is an empty hash.

## `rvmrc`

A hash of system-wide `rvmrc` options. The key is the RVM setting name
(in String or Symbol form) and the value is the desired setting value.
An example used on a build box might be:

    node[:rvm][:rvmrc] = {
      'rvm_gemset_create_on_use_flag' => 1,
      'rvm_trus_rvmrcs_flag'          => 1
    }

The default is an empty hash.

## `root_path`

The path prefix to RVM in a system-wide installation. The default is
`/usr/local/rvm`.

## `group_users`

A list of users that will be added to the `rvm` group. These users
will then be able to manage RVM in a system-wide installation. The default
is an empty list.

# RESOURCES AND PROVIDERS

## rvm_ruby

### Actions

| Action  | Description | Default |
| ------- | ----------- | ------- |
| install | .           | Yes     |

# USAGE

# LICENSE and AUTHOR

Author:: Fletcher Nichol (<fnichol@nichol.ca>)

Contributors:: Bram Swenson (<bram@craniumisajar.com>)

Contributors:: Phil Cohen (http://phlippers.net/)

Copyright:: 2010, 2011, Fletcher Nichol

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
