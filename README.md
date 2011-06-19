# DESCRIPTION

Installs a system-wide RVM and manages installed rubies. Several lightweight
resources and providers (LWRP) are also defined.

# REQUIREMENTS

## Platform

Tested on Ubuntu 10.04/10.10, Debian 6.0, and OpenSuSE 11.4. Also reported
to work on CentOS, Redhat and Fedora.

## Cookbooks

There are no explicit external cookbook dependencies. However, the Opscode
*java* cookbook can be used when installing JRuby.

# RECIPES

## default

Installs RVM system-wide, builds RVM Rubies, sets a default Ruby, installs
any gems and global gems. **Note** that the `system` recipe is included to
install RVM.

## system

Installs any package dependencies and installs RVM system-wide.

## vagrant

An optional recipe if Chef is installed in a non-RVM Ruby in a
[Vagrant](http://vagrantup.com) virtual machine. This recipe adds the
default vagrant user to the RVM unix group and installs a `chef-solo`
wrapper script so Chef doesn't need to be re-installed in the default
RVM Ruby.

## gem_package

An experimental recipe that patches the
[gem_package resource](http://wiki.opscode.com/display/chef/Resources#Resources-Package)
to use the `Chef::Provider::Package::RVMRubygems` provider. An attribute
`rvm/gem_package/rvm_string` will determine which RVM ruby is used for
install/remove/upgrade/purge actions. This may help when using a third
party or upstream cookbook that assumes a non-RVM managed system ruby.

**Note:** When this recipe is included it will force RVM to be
installed in the
[compilation phase](http://wiki.opscode.com/display/chef/Evaluate+and+Run+Resources+at+Compile+Time).
This will ensure that all rubies can be available if any `gem_package`
resource calls are issued from other cookbooks during the compilation phase.

**Warning:** Here be dragons! This is either brilliant or the dumbest idea
ever, so feedback is appreciated.

# USAGE

The typical case will be to include the `rvm` recipe which will install RVM
system-wide, install all listed RVM rubies and gems and set a default RVM ruby.

If node is running in a Vagrant VM, then the `rvm::vagrant` recipe can help
with resolving the *chef-solo* binary on subsequent provision executions.

There are also several resources declared which can be used in other recipes
that are RVM-supported. See below for more details.

# ATTRIBUTES

## `default_ruby`

The default ruby for RVM. If the RVM ruby is not installed, it will be
built as a pre-requisite. The value can also contain a gemset in the form of
`"ruby-1.8.7-p330@awesome"`.

**Note:** a fully qualified RVM string name needs to be used, which can be
found when running `rvm list known`.

The default is `"ruby-1.9.2-p180"`. To disable a default ruby from being
set, use an empty string (`""`) or a value of `"system"`.

## `rubies`

A list of additional RVM rubies to be built and installed. This list does not need to
necessarily contain your default ruby as the `rvm_default_ruby` resource will take
care of installing itself. For example:

    node['rvm']['rubies'] = [ "ree-1.8.7", "jruby-1.5.6" ]

**Note:** a fully qualified RVM string name needs to be used, which can be
found when running `rvm list known`.

The default is an empty array. To disable a default ruby from being
installed, see the `install_rubies` attribute.

## `install_rubies`

Can enable or disable installation of a default ruby and additional rubies set
attribute metadata. The primary use case for this attribute is when you don't
want any rubies installed (but you want RVM installed). To do so:

    node['rvm']['install_rubies'] = "false"

The default is `"true"`.

## `global_gems`

A list of gem hashes to be installed into the *global* gemset in each
installed RVM ruby. The RVM global.gems files will be added to and all
installed rubies will be iterated over to ensure full installation coverage.
See the `rvm_gem` resource for more details about the options for each
gem hash. The default puts bundler in each ruby:

    node['rvm']['global_gems'] = [
      { 'name' => "bundler" }
    ]

## `gems`

A list of gem hashes to be installed into arbitrary RVM rubies and gemsets.
See the `rvm_gem` resource for more details about the options for each gem
hash and target ruby environment. The default is an empty hash.

## `rvmrc`

A hash of system-wide `rvmrc` options. The key is the RVM setting name
(in String or Symbol form) and the value is the desired setting value.
An example used on a build box might be:

    node['rvm']['rvmrc'] = {
      'rvm_gemset_create_on_use_flag' => 1,
      'rvm_trust_rvmrcs_flag'         => 1
    }

The default is an empty hash.

## `branch`

A specific git branch to use when installing system-wide. For example:

    node['rvm']['branch'] = "crazy"

The default is `nil` which corresponds to the master branch.

## `version`

A specific tagged version to use when installing system-wide. This value is
passed directly to the `rvm-installer` script and current valid values are:
`"head"` (the default, last git commit), `"latest"` (last tagged release
version) and a specific tagged version of the form `"1.2.3"`. You may want
to use a specific version of RVM to prevent differences in deployment from
one day to the next (RVM head moves pretty darn quickly):

    node['rvm']['version'] = "1.5.3"

The default is `nil`, which corresponds to RVM `"head"`.

## `upgrade`

Determines how to handle installing updates to the RVM framework. There are
currently 3 valid values:

* `"none"`, `false`, or `nil`: will not update RVM and leave it in its
  current state. **Note** that this is the default.
* `"latest"`: runs `rvm get latest` which downloads and installs the latest
  *"stable"* RVM release listed by
  [http://rvm.beginrescueend.com/releases/stable-version.txt](http://rvm.beginrescueend.com/releases/stable-version.txt).
* `"head"`: runs the infamous `rvm get head` which clones (via git) and installs
  the latest RVM repository HEAD.

## `root_path`

The path prefix to RVM in a system-wide installation. The default is
`"/usr/local/rvm"`.

## `group_id`

The Unix *GID* to be used for the `rvm` group. If this attribute is set,
the group will be created in the compilation phase to avoid any collisions
with expected *GID*s in other cookbooks. If left at the default value,
the RVM installer will create this group as normal. The default is
`default`.

## `installer_url`

The URL that provides the RVM installer. The default is
`http://rvm.beginrescueend.com/install/rvm`.

## `group_users`

A list of users that will be added to the `rvm` group. These users
will then be able to manage RVM in a system-wide installation. The default
is an empty list.

## `rvm_gem_options`

These options are passed to the *gem* command in a RVM environment.
In the interest of speed, rdoc and ri docs will not be generated by default.
To re-enable the documentation generation set:

    node['rvm']['rvm_gem_options'] = "--rdoc --ri"

The default is `"--no-rdoc --no-ri"`.

## `vagrant/system_chef_solo`

If using the `vagrant` recipe, this sets the path to the package-installed
*chef-solo* binary. The default is `"/opt/ruby/bin/chef-solo"`.

## `gem_package/rvm_string`

If using the `gem_package` recipe, this determines which ruby or rubies will
be used by the `gem_package` resource in other cookbooks. The value can be
either a *String* (for example `ruby-1.8.7-p334`) or an *Array* of RVM ruby
strings (for example `['ruby-1.8.7-p334', 'system']`). To target an underlying
unmanaged system ruby you can use `system`.

The default is the value of the `default_ruby` attribute.

# RESOURCES AND PROVIDERS

## rvm_ruby

### Actions

Action    |Description                   |Default
----------|------------------------------|-------
install   |Build and install an RVM ruby. See [RVM rubies/installing](http://rvm.beginrescueend.com/rubies/installing/) for more details. |Yes
remove    |Remove the ruby, source files and optional gemsets/archives. See [RVM rubies/removing](http://rvm.beginrescueend.com/rubies/removing/) for more details. |
uninstall |Just remove the ruby and leave everything else. See [RVM rubies/removing](http://rvm.beginrescueend.com/rubies/removing/) for more details. |

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
ruby_string |**Name attribute:** a fully qualified RVM ruby string that could contain a gemset. See the section *RVM Ruby Strings* for more details. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be stripped. |`nil`

### Examples

#### Install Ruby

    rvm_ruby "ree-1.8.7-2011.01" do
      action :install
    end

    rvm_ruby "jruby-1.5.6"

**Note:** the install action is default, so the second example is a more common
usage.

#### Remove Ruby

    rvm_ruby "ree-1.8.7-2011.01" do
      action :remove
    end

**Note:** the RVM documentation mentions that this method is far preferred to
using uninstall since it purges almost everything.

#### Uninstall Ruby

    rvm_ruby "ree-1.8.7-2011.01" do
      action :uninstall
    end

## rvm_default_ruby

This resource sets the default RVM ruby, optionally with gemset. The given
ruby will be installed if it isn't already and a gemset will be created in
none currently exist. If multiple declarations are used then the last executed
one "wins".

### Actions

Action    |Description                   |Default
----------|------------------------------|-------
create    |Set the default RVM ruby. See [RVM rubies/default](http://rvm.beginrescueend.com/rubies/default/) for more details. |Yes

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
ruby_string |**Name attribute:** a fully qualified RVM ruby string that could contain a gemset. See the section *RVM Ruby Strings* for more details. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be included. |`nil`

### Examples

#### Setting The Default Ruby

    rvm_default_ruby "ree-1.8.7-2011.01" do
      action :create
    end

    rvm_default_ruby "jruby-1.5.6"

**Note:** the create action is default, so the second example is a more common
usage.

## rvm_environment

This resource ensures that the specified RVM ruby is installed and the optional
gemset is created. It is a convenience resource which wraps `rvm_ruby` and
`rvm_gemset` so it can be used as a sort of *über ruby* resource which
parallels the `rvm_default_ruby` resource.

### Actions

Action    |Description                   |Default
-------|------------------------------|-------
create |Installs the specified RVM ruby and gemset. |Yes

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
ruby_string |**Name attribute:** a fully qualified RVM ruby string that could contain a gemset. See the section *RVM Ruby Strings* for more details. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be used. |`nil`

### Examples

#### Creating A Passenger Environment In Production

    rvm_environment "ree-1.8.7-2011.01@passenger"

## rvm_gemset
See [RVM gemsets](http://rvm.beginrescueend.com/gemsets/) for more background
concerning gemsets.

### Actions

Action    |Description                   |Default
----------|------------------------------|-------
create    |Creates a new gemset in a given RVM ruby. See [RVM gemsets/creating](http://rvm.beginrescueend.com/gemsets/creating/) for more details. |Yes
update    |Update all gems installed to the gemset in a given RVM ruby. |
empty     |Remove all gems installed to the gemset in a given RVM ruby. See [RVM gemsets/emptying](http://rvm.beginrescueend.com/gemsets/emptying/) for more details. |
delete    |Delete gemset from the given RVM ruby. See [RVM gemsets/deleting](http://rvm.beginrescueend.com/gemsets/deleting/) for more details. |

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
gemset      |**Name attribute:**  Either a fully qualified RVM ruby string containing a gemset or a bare gemset name. If only the gemset name is given, then the `ruby_string` attribute must be used to indicate which RVM ruby to target. |`nil`
ruby_string |A fully qualified RVM ruby string that should not contain a gemset. See the section *RVM Ruby Strings* for more details. |`nil`

### Examples

#### Creating A Gemset

    rvm_gemset "rails" do
      ruby_string "ruby-1.9.2-p136"
      action      :create
    end

    rvm_gemset "ruby-1.9.2-p136@rails"

**Note:** the create action is default, so the second example is a more common
usage.

#### Updating A Gemset

    rvm_gemset "jruby-1.6.0.RC2@development" do
      action :update
    end

#### Emptying A Gemset

    rvm_gemset "development" do
      ruby_string "jruby-1.6.0.RC2"
      action      :empty
    end

#### Deleting A Gemset

    rvm_gemset "ruby-1.9.2-p136@rails" do
      action :delete
    end

## rvm_gem
This resource is a close analog to the `gem_package` provider/resource which
is RVM-aware. See the Opscode
[package resource](http://wiki.opscode.com/display/chef/Resources#Resources-Package)
and [gem package options](http://wiki.opscode.com/display/chef/Resources#Resources-GemPackageOptions)
pages for more details.

### Actions

Action    |Description                   |Default
----------|------------------------------|-------
install   |Install a gem - if version is provided, install that specific version. |Yes
upgrade   |Upgrade a gem - if version is provided, upgrade to that specific version.|
remove    |Remove a gem.|
purge     |Purge a gem.|

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
package_name |**Name Attribute:** the name of the gem to install.|`nil`
ruby_string |A fully qualified RVM ruby string that could contain a gemset. See the section *RVM Ruby Strings* for more details. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be used. |`"default"`
version     |The specific version of the gem to install/upgrade. |`nil`
options     |Add additional options to the underlying gem command. |`nil`
source      |Provide an additional source for gem providers (such as rubygems). |`nil`

### Examples

#### Install A Gem

    rvm_gem "thor" do
      ruby_string "ruby-1.8.7-p330"
      action      :install
    end

    rvm_gem "json" do
      ruby_string "ruby-1.8.7-p330@awesome"
    end

    rvm_gem "nokogiri" do
      ruby_string "jruby-1.5.6"
      version     "1.5.0.beta.4"
      action      :install
    end

**Note:** the install action is default, so the second example is a more common
usage. Gemsets can also be specified.

#### Keep A Gem Up To Date

    rvm_gem "homesick" do
      action :upgrade
    end

**Note:** the default RVM ruby will be targetted if no `ruby_string` attribute
is given.

#### Remove A Gem

    rvm_gem "nokogiri" do
      ruby_string "jruby-1.5.6"
      version     "1.4.4.2"
      action      :remove
    end

## rvm_global_gem
This resource will use the `rvm_gem` resource to manage a gem in the *global*
gemset accross all RVM rubies. An entry will also be made/removed in RVM's
*global.gems* file. See the Opscode
[package resource](http://wiki.opscode.com/display/chef/Resources#Resources-Package)
and [gem package options](http://wiki.opscode.com/display/chef/Resources#Resources-GemPackageOptions)
pages for more details.

### Actions

Action    |Description                   |Default
----------|------------------------------|-------
install   |Install a gem across all rubies - if version is provided, install that specific version. |Yes
upgrade   |Upgrade a gem across all rubies - if version is provided, upgrade to that specific version.|
remove    |Remove a gem across all rubies.|
purge     |Purge a gem across all rubies.|

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
package_name |**Name Attribute:** the name of the gem to install.|`nil`
version     |The specific version of the gem to install/upgrade. |`nil`
options     |Add additional options to the underlying gem command. |`nil`
source      |Provide an additional source for gem providers (such as rubygems). |`nil`
gem_binary  |A gem_package attribute to specify a gem binary. |`gem`

## rvm_shell
This resource is a wrapper for the `script` resource which wraps the code block
in an RVM-aware environment.. See the Opscode [script resource](http://wiki.opscode.com/display/chef/Resources#Resources-Script) page for more details.

### Actions

Action    |Description                   |Default
----------|------------------------------|-------
run       |Run the script                |Yes
nothing   |Do not run this command       |

Use `action :nothing` to set a command to only run if another resource
notifies it.

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
name        |**Name Attribute:** Name of the command to execute. |name
ruby_string |A fully qualified RVM ruby string that could contain a gemset. See the section *RVM Ruby Strings* for more details. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be used. |`"default"`
code        |Quoted script of code to execute. |`nil`
creates     |A file this command creates - if the file exists, the command will not be run. |`nil`
cwd         |Current working director to run the command from. |`nil`
environment |A has of environment variables to set before running this command. |`nil`
group       |A group or group ID that we should change to before running this command. |`nil`
path        |An array of paths to use when searching for the command. |`nil`, uses system path
returns     |The return value of the command (may be an array of accepted values) - this resource raises an exception if the return value(s) do not match. |`0`
timeout     |How many seconds to let the command run before timing out. |`nil`
user        |A user name or user ID that we should change to before running this command. |`nil`
umask       |Umask for files created by the command. |`nil`

### Examples

#### Run A Rake Task

    rvm_shell "migrate_rails_database" do
      ruby_string "ruby-1.8.7-p334@webapp"
      user        "deploy"
      group       "deploy"
      cwd         "/srv/webapp/current"
      code        %{rake RAILS_ENV=production db:migrate}
    end

## rvm_wrapper

This resource creates a wrapper script for a binary or list of binaries in
a given RVM ruby (and optional gemset). The given ruby will be installed if
it isn't already and a gemset will be created in none currently exist.

### Actions

Action    |Description                   |Default
-------|------------------------------|-------
create |Creates one or more wrapper scripts. |Yes

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
prefix      |**Name attribute:** a prefix string for the wrapper script name. |`nil`
ruby_string |A fully qualified RVM ruby string that could contain a gemset. See the section *RVM Ruby Strings* for more details. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be used. |`nil`
binary      |A single binary to be wrapped. If this attribute is used do not set values for the `binaries` attribute. |`nil`
binaries    |A list of binaries to be wrapped. If this attribute is used do not set a value for the `binary` attribute. |`nil`

**Note:** only `binary` or `binaries` should be used by themselves (never at
the same time).

### Examples

#### Wrapping A Ruby CLI

    rvm_wrapper "sys" do
      ruby_string   "jruby-1.5.6@utils"
      binary        "thor"
    end

This will create a wrapper script called `sys_thor` in the `bin` directory
under `node['rvm']['root_path']`.

#### Wrapping A List Of Binaries

    rvm_wrapper "test" do
      ruby_string   "default@testing"
      binaries      [ "rspec", "cucumber" ]
      action        :create
    end

# DEVELOPMENT

* Source hosted at [GitHub](https://github.com/fnichol/chef-rvm)
* Report issues/Questions/Feature requests on [GitHub Issues](https://github.com/fnichol/chef-rvm/issues)

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every seperate change you make.

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
