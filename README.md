# Description

Manages system-wide and per-user [RVM][rvm]s and manages installed Rubies.
Several lightweight resources and providers ([LWRP][lwrp]) are also defined.

# Requirements

## Chef

Tested on 0.10.2/0.10.4 and 0.9.16 but newer and older versions (of 0.9.x)
should work just fine. Due to the `rvm_gem` implementation, versions 0.8.x
of Chef currently will **not** work (see [GH-50][gh50]).

File an [issue][issues] if this isn't the case.

## Platform

The following platforms have been tested with this cookbook, meaning that
the recipes and LWRPs run on these platforms without error:

* ubuntu (10.04/10.10/11.04)
* debian (6.0)
* mac_os_x (10.6/10.7)
* suse (openSUSE, SLES)
* centos
* amazon (2011.09)
* redhat
* fedora

Please [report][issues] any additional platforms so they can be added.

## Cookbooks

There are **no** external cookbook dependencies. However, if you are
installing [JRuby][jruby] then a Java runtime will need to be installed.
The Opscode [java cookbook][java_cb] can be used on supported platforms.

# Installation

Depending on the situation and use case there are several ways to install
this cookbook. All the methods listed below assume a tagged version release
is the target, but omit the tags to get the head of development. A valid
Chef repository structure like the [Opscode repo][chef_repo] is also assumed.

## Using Librarian

The [Librarian][librarian] gem aims to be Bundler for your Chef cookbooks.
Include a reference to the cookbook in a **Cheffile** and run
`librarian-chef install`. To install with Librarian:

    gem install librarian
    cd chef-repo
    librarian-chef init
    cat >> Cheffile <<END_OF_CHEFFILE
    cookbook 'rvm',
      :git => 'git://github.com/fnichol/chef-rvm.git', :ref => 'v0.8.6'
    END_OF_CHEFFILE
    librarian-chef install

## Using knife-github-cookbooks

The [knife-github-cookbooks][kgc] gem is a plugin for *knife* that supports
installing cookbooks directly from a GitHub repository. To install with the
plugin:

    gem install knife-github-cookbooks
    cd chef-repo
    knife cookbook github install fnichol/chef-rvm/v0.8.6

## As a Git Submodule

A common practice (which is getting dated) is to add cookbooks as Git
submodules. This is accomplishes like so:

    cd chef-repo
    git submodule add git://github.com/fnichol/chef-rvm.git cookbooks/rvm
    git submodule init && git submodule update

**Note:** the head of development will be linked here, not a tagged release.

## As a Tarball

If the cookbook needs to downloaded temporarily just to be uploaded to a Chef
Server or Opscode Hosted Chef, then a tarball installation might fit the bill:

    cd chef-repo/cookbooks
    curl -Ls https://github.com/fnichol/chef-rvm/tarball/v0.8.6 | tar xfz - && \
      mv fnichol-chef-rvm-* rvm

## From the Opscode Community Platform

This cookbook is not currently available on the site due to the flat
namespace for cookbooks. There is some community work to be done here.

# Usage

## RVM Installed System-Wide with Rubies

Most likely, this is the typical case. Include `recipe[rvm::system]` in your
run_list and override the defaults you want changed. See below for more
details.

## RVM Installed For A Specific User with Rubies

If you want a per-user install (like on a Mac/Linux workstation for
development), include `recipe[rvm::user]` in your run_list and add a user
hash to the `user_installs` attribute list. For example:

    node['rvm']['user_installs'] = [
      { 'user'          => 'wigglebottom'
        'default_ruby'  => 'rbx',
        'rubies'        => ['1.9.2', '1.8.7']
      }
    ]

See below for more details.

## RVM Installed System-Wide and LWRPs Defined

If you want to manage your own RVM environment with the provided [LWRP][lwrp]s,
then include `recipe[rvm::system_install]` in your run_list to prevent
a default RVM Ruby being installed. See the **Resources and Providers**
section for more details.

## RVM Installed For A Specific User and LWRPs Defined

If you want to manage your own RVM environment for users with the provided
LWRPs, then include `recipe[rvm::user_install]` in your run_list and add a
user hash to the `user_installs` attribute list. For example:

    node['rvm']['user_installs'] = [
      { 'user' => 'wigglebottom' }
    ]

See the **Resources and Providers** section for more details.

## Ultra-Minimal Access To LWRPs

Simply include `recipe[rvm]` in your run_list and the LWRPs will be available
to use in other cookbooks. See the **Resources and Providers** section for
more details.

## Other Use Cases

* If node is running in a Vagrant VM, then including `recipe[rvm::vagrant]`
in your run_list can help with resolving the *chef-solo* binary on subsequent
provision executions.
* If you want other Chef cookbooks to install RubyGems in RVM-managed Rubies,
you can try including `recipe[rvm::gem_package]` in your run_list. Please
read the recipe details before attempting.

# Recipes

## default

Installs the RVM gem and initializes Chef to use the Lightweight Resources
and Providers ([LWRPs][lwrp]).

Use this recipe explicitly if you only want access to the LWRPs provided.

## system_install

Installs the RVM codebase system-wide (that is, into `/usr/local/rvm`). This
recipe includes *default*.

Use this recipe by itself if you want RVM installed system-wide but want
to handle installing Rubies, invoking LWRPs, etc..

## system

Installs the RVM codebase system-wide (that is, into `/usr/local/rvm`) and
installs Rubies, global gems, and specific gems driven off attribute metadata.
This recipe includes *default* and *system_install*.

Use this recipe by itself if you want RVM system-wide with Rubies installed,
etc.

## user_install

Installs the RVM codebase for a list of users (selected from the
`node['rvm']['user_installs']` hash). This recipe includes *default*.

Use this recipe by itself if you want RVM installed for specific users in
isolation but want each user to handle installing Rubies, invoking LWRPs, etc.

## user

Installs the RVM codebase for a list of users (selected from the
`node['rvm']['user_installs']` hash) and installs Rubies, global gems, and
specific gems driven off attribute metadata. This recipe includes *default*
and *user_install*.

Use this recipe by itself if you want RVM installed for specific users in
isolation with Rubies installed, etc.

## vagrant

An optional recipe if Chef is installed in a non-RVM Ruby in a
[Vagrant][vagrant] virtual machine. This recipe adds the default *vagrant*
user to the RVM unix group and installs a `chef-solo` wrapper script so Chef
doesn't need to be re-installed in the default RVM Ruby.

## gem_package

An experimental recipe that patches the [gem_package resource][gem_package]
to use the `Chef::Provider::Package::RVMRubygems` provider. An attribute
`rvm/gem_package/rvm_string` will determine which RVM Ruby is used for
install/remove/upgrade/purge actions. This may help when using a third
party or upstream cookbook that assumes a non-RVM managed system Ruby.

**Note:** When this recipe is included it will force RVM to be
installed in the [compilation phase][compilation]. This will ensure that all
Rubies can be available if any `gem_package` resource calls are issued from
other cookbooks during the compilation phase.

**Warning:** [Here be dragons][dragons]! This is either brilliant or the
dumbest idea ever, so feedback is appreciated.

# Attributes

## default_ruby

The default Ruby for RVM installed system-wide. If the RVM Ruby is not
installed, it will be built as a pre-requisite. The value can also contain a
gemset in the form of `"ruby-1.8.7-p352@awesome"`.

The default is `"ruby-1.9.2-p290"`. To disable a default Ruby from being
set, use an empty string (`""`) or a value of `"system"`.

## user_default_ruby

The default Ruby for RVMs installed per-user when not explicitly set for that
user. If the RVM Ruby is not installed, it will be built as a pre-requisite.
The value can also contain a gemset in the form of `"ruby-1.8.7-p352@awesome"`.

The default is `"ruby-1.9.2-p290"`. To disable a default Ruby from being
set, use an empty string (`""`) or a value of `"system"`.

## rubies

A list of additional RVM system-wide Rubies to be built and installed. This
list does not need to necessarily contain your default Ruby as the
`rvm_default_ruby` resource will take care of installing itself. For example:

    node['rvm']['rubies'] = [ "ree-1.8.7", "jruby" ]

The default is an empty array: `[]`.

## user_rubies

A list of additional RVM Rubies to be built and installed per-user when not
explicitly set. This list does not need to necessarily contain your default
Ruby as the `rvm_default_ruby` resource will take care of installing itself.
For example:

    node['rvm']['user_rubies'] = [ "ree-1.8.7", "jruby" ]

The default is an empty array: `[]`.

## global_gems

A list of gem hashes to be installed into the *global* gemset in each
installed RVM Ruby sytem-wide. The **global.gems** files will be added to and
all installed Rubies will be iterated over to ensure full installation
coverage. See the `rvm_gem` resource for more details about the options for
each gem hash.

The default puts bundler and rake in each Ruby:

    node['rvm']['global_gems'] = [
      { 'name'    => 'bundler' },
      { 'name'    => 'rake',
        'version' => '0.9.2'
      }
    ]

## user_global_gems

A list of gem hashes to be installed into the *global* gemset in each
installed RVM Ruby for each user when not explicitly set. The
**global.gems** files will be added to and all installed Rubies will be
iterated over to ensure full installation coverage. See the `rvm_gem`
resource for more details about the options for each gem hash.

The default puts bundler and rake in each Ruby:

    node['rvm']['user_global_gems'] = [
      { 'name'    => 'bundler' },
      { 'name'    => 'rake',
        'version' => '0.9.2'
      }
    ]

## gems

A list of gem hashes to be installed into arbitrary RVM Rubies and gemsets
system-wide. See the `rvm_gem` resource for more details about the options for
each gem hash and target Ruby environment. For example:

    node['rvm']['gems'] = {
      'ruby-1.9.2-p280' => [
        { 'name'    => 'vagrant' },
        { 'name'    => 'veewee' },
        { 'name'    => 'rake',
          'version' => '0.9.2'
        }
      ]
      'jruby' => [
        { 'name'    => 'nokogiri',
          'version' => '1.5.0.beta.2'
        },
        { 'name'    => 'warbler' }
      ]
    }

The default is an empty hash: `{}`.

## user_gems

A list of gem hashes to be installed into arbitrary RVM Rubies and gemsets
for each user when not explicitly set. See the `rvm_gem` resource for more
details about the options for each gem hash and target Ruby environment. See
the `gems` attribute for an example.

The default is an empty hash: `{}`.

## rvmrc

A hash of system-wide `rvmrc` options. The key is the RVM setting name
(in String or Symbol form) and the value is the desired setting value.
An example used on a build box might be:

    node['rvm']['rvmrc'] = {
      'rvm_project_rvmrc'             => 1,
      'rvm_gemset_create_on_use_flag' => 1,
      'rvm_trust_rvmrcs_flag'         => 1
    }

The default is an empty hash: `{}`.

## user_installs

A list of user specific RVM installation hashes. The `user_install` and
`user` recipes use this attribute to determine per-user installation settings.
The hash keys correspond to the default/system equivalents. For example:

    node['rvm']['user_installs'] = [
      { 'user'            => 'jdoe',
        'upgrade'         => "head",
        'default_ruby'    => 'ree',
        'rvm_gem_options' => "",
        'global_gems'     => [
          { 'name'    => 'bundler',
            'version' => '1.1.pre.7'
          },
          { 'name'    => 'rake' }
        ]
      },
      { 'user'          => 'jenkins',
        'version'       => '1.7.0',
        'default_ruby'  => 'jruby-1.6.3',
        'rubies'        => ['1.8.7', '1.9.2', 'ree', 'rbx'],
        'rvmrc'         => {
          'rvm_project_rvmrc'             => 1,
          'rvm_gemset_create_on_use_flag' => 1,
          'rvm_pretty_print_flag'         => 1
        },
        'global_gems'   => [
          { 'name'    => 'bundler',
            'version' => '1.1.pre.7'
          },
          { 'name'    => 'rake',
            'version' => '0.8.7'
          }
        ]
      }
    ]

The default is an empty list: `[]`.

## installer_url

The URL that provides the RVM installer.

The default is `"https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer"`.

## branch

A specific git branch to use when installing system-wide. For example:

    node['rvm']['branch'] = "crazy"

The default is `nil` which corresponds to the master branch.

## version

A specific tagged version to use when installing system-wide. This value is
passed directly to the `rvm-installer` script and current valid values are:
`"head"` (the default, last git commit), `"latest"` (last tagged release
version) and a specific tagged version of the form `"1.2.3"`. You may want
to use a specific version of RVM to prevent differences in deployment from
one day to the next (RVM head moves pretty darn quickly):

    node['rvm']['version'] = "1.7.0"

The default is `nil`, which corresponds to RVM `"head"`.

## upgrade

Determines how to handle installing updates to the RVM framework system-wide.
There are currently 3 valid values:

* `"none"`, `false`, or `nil`: will not update RVM and leave it in its
  current state.
* `"latest"`: runs `rvm get latest` which downloads and installs the latest
  *"stable"* RVM release listed by
  [https://rvm.beginrescueend.com/releases/stable-version.txt][stable].
* `"head"`: runs the infamous `rvm get head` which clones (via git) and
  installs the latest RVM repository HEAD.

The default is `"none"`.

## root_path

The path prefix to RVM in a system-wide installation.

The default is `"/usr/local/rvm"`.

## group_id

The Unix *GID* to be used for the `rvm` group. If this attribute is set,
the group will be created in the compilation phase to avoid any collisions
with expected *GID*s in other cookbooks. If left at the default value,
the RVM installer will create this group as normal.

The default is `default`.

## group_users

A list of users that will be added to the `rvm` group. These users
will then be able to manage RVM in a system-wide installation.

The default is an empty list: `[]`.

## rvm_gem_options

These options are passed to the *gem* command in an RVM environment.
In the interest of speed, rdoc and ri docs will not be generated by default.
To re-enable the documentation generation set:

    node['rvm']['rvm_gem_options'] = "--rdoc --ri"

The default is `"--no-rdoc --no-ri"`.

## install_rubies (Future Deprecation)

Can enable or disable installation of a default Ruby and additional Rubies
system-wide. For example:

    node['rvm']['install_rubies'] = "false"

The default is `"true"`.

**Note:** This remains a legacy setting and will be deprecated in
the next minor version release.

## user_install_rubies (Future Deprecation)

Can enable or disable installation of a default Ruby and additional Rubies
per user. For example:

    node['rvm']['user_install_rubies'] = "false"

The default is `"true"`.

**Note:** This remains a legacy setting and will be deprecated in
the next minor version release.

## gem_package/rvm_string

If using the `gem_package` recipe, this determines which Ruby or Rubies will
be used by the `gem_package` resource in other cookbooks. The value can be
either a *String* (for example `ruby-1.8.7-p334`) or an *Array* of RVM Ruby
strings (for example `['ruby-1.8.7-p334', 'system']`). To target an underlying
unmanaged system Ruby you can use `system`.

The default is the value of the `default_ruby` attribute.

## vagrant/system_chef_solo

If using the `vagrant` recipe, this sets the path to the package-installed
*chef-solo* binary.

The default is `"/opt/ruby/bin/chef-solo"`.

# Resources and Providers

## rvm_ruby

### Actions

Action    |Description                   |Default
----------|------------------------------|-------
install   |Build and install an RVM Ruby. See [RVM rubies/installing][rvm_install] for more details. |Yes
remove    |Remove the Ruby, source files and optional gemsets/archives. See [RVM rubies/removing][rvm_remove] for more details. |
uninstall |Just remove the Ruby and leave everything else. See [RVM rubies/removing][rvm_remove] for more details. |

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
ruby_string |**Name attribute:** an RVM Ruby string that could contain a gemset. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be stripped. |`nil`
user        |A users's isolated RVM installation on which to apply an action. The default value of `nil` denotes a system-wide RVM installation is being targeted. **Note:** if specified, the user must already exist. |`nil`

### Examples

#### Install Ruby

    rvm_ruby "ree" do
      action :install
    end

    rvm_ruby "jruby-1.6.3"

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
      action  :uninstall
      user    "jenkins"
    end

**Note:** The RVM installation for the *jenkins* user will be acted upon.

## rvm_default_ruby

This resource sets the default RVM Ruby, optionally with gemset. The given
Ruby will be installed if it isn't already and a gemset will be created in
none currently exist. If multiple declarations are used then the last executed
one "wins".

### Actions

Action    |Description                   |Default
----------|------------------------------|-------
create    |Set the default RVM Ruby. See [RVM rubies/default][rvm_default] for more details. |Yes

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
ruby_string |**Name attribute:** an RVM Ruby string that could contain a gemset. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be included. |`nil`
user        |A users's isolated RVM installation on which to apply an action. The default value of `nil` denotes a system-wide RVM installation is being targeted. **Note:** if specified, the user must already exist. |`nil`

### Examples

#### Setting The Default Ruby

    rvm_default_ruby "ree" do
      action :create
    end

    rvm_default_ruby "jruby-1.5.6"

**Note:** the create action is default, so the second example is a more common
usage.

## rvm_environment

This resource ensures that the specified RVM Ruby is installed and the optional
gemset is created. It is a convenience resource which wraps `rvm_ruby` and
`rvm_gemset` so it can be used as a sort of *über Ruby* resource which
parallels the `rvm_default_ruby` resource.

### Actions

Action    |Description                   |Default
-------|------------------------------|-------
create |Installs the specified RVM Ruby and gemset. |Yes

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
ruby_string |**Name attribute:** an RVM Ruby string that could contain a gemset. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be used. |`nil`
user        |A users's isolated RVM installation on which to apply an action. The default value of `nil` denotes a system-wide RVM installation is being targeted. **Note:** if specified, the user must already exist. |`nil`

### Examples

#### Creating A Passenger Environment In Production

    rvm_environment "ree-1.8.7-2011.01@passenger"

## rvm_gemset
See [RVM gemsets][rvm_gemsets] for more background concerning gemsets.

### Actions

Action    |Description                   |Default
----------|------------------------------|-------
create    |Creates a new gemset in a given RVM Ruby. See [RVM gemsets/creating][rvm_create_gemset] for more details. |Yes
update    |Update all gems installed to the gemset in a given RVM Ruby. |
empty     |Remove all gems installed to the gemset in a given RVM Ruby. See [RVM gemsets/emptying][rvm_empty_gemset] for more details. |
delete    |Delete gemset from the given RVM Ruby. See [RVM gemsets/deleting][rvm_delete_gemset] for more details. |

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
gemset      |**Name attribute:**  Either an RVM Ruby string containing a gemset or a bare gemset name. If only the gemset name is given, then the `ruby_string` attribute must be used to indicate which RVM Ruby to target. |`nil`
ruby_string |An RVM Ruby string that should not contain a gemset. |`nil`
user        |A users's isolated RVM installation on which to apply an action. The default value of `nil` denotes a system-wide RVM installation is being targeted. **Note:** if specified, the user must already exist. |`nil`

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
      ruby_string "jruby-1.6.3"
      action      :empty
    end

#### Deleting A Gemset

    rvm_gemset "ruby-1.9.2-p136@rails" do
      action :delete
    end

## rvm_gem

This resource is a close analog to the `gem_package` provider/resource which
is RVM-aware. See the Opscode [package resource][package_resource] and
[gem package options][gem_package_options] pages for more details.

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
ruby_string |An RVM Ruby string that could contain a gemset. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be used. |`"default"`
version     |The specific version of the gem to install/upgrade. |`nil`
options     |Add additional options to the underlying gem command. |`nil`
source      |Provide an additional source for gem providers (such as RubyGems). This can also include a file system path to a `.gem` file such as `/tmp/json-1.5.1.gem`. |`nil`
user        |A users's isolated RVM installation on which to apply an action. The default value of `nil` denotes a system-wide RVM installation is being targeted. **Note:** if specified, the user must already exist. |`nil`

### Examples

#### Install A Gem

    rvm_gem "thor" do
      ruby_string "ruby-1.8.7-p352"
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

#### Install A Gem From A Local File

    rvm_gem "json" do
      ruby_string "ree@project"
      source      "/tmp/json-1.5.1.gem"
      version     "1.5.1"
    end

#### Keep A Gem Up To Date

    rvm_gem "homesick" do
      action :upgrade
    end

**Note:** the default RVM Ruby will be targeted if no `ruby_string` attribute
is given.

#### Remove A Gem

    rvm_gem "nokogiri" do
      ruby_string "jruby-1.5.6"
      version     "1.4.4.2"
      action      :remove
    end

## rvm_global_gem

This resource will use the `rvm_gem` resource to manage a gem in the *global*
gemset accross all RVM Rubies. An entry will also be made/removed in RVM's
*global.gems* file. See the Opscode [package resource][package_resource] and
[gem package options][gem_package_options] pages for more details.

### Actions

Action    |Description                   |Default
----------|------------------------------|-------
install   |Install a gem across all Rubies - if version is provided, install that specific version. |Yes
upgrade   |Upgrade a gem across all Rubies - if version is provided, upgrade to that specific version.|
remove    |Remove a gem across all Rubies.|
purge     |Purge a gem across all Rubies.|

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
package_name |**Name Attribute:** the name of the gem to install.|`nil`
version     |The specific version of the gem to install/upgrade. |`nil`
options     |Add additional options to the underlying gem command. |`nil`
source      |Provide an additional source for gem providers (such as RubyGems). |`nil`
gem_binary  |A gem_package attribute to specify a gem binary. |`gem`
user        |A users's isolated RVM installation on which to apply an action. The default value of `nil` denotes a system-wide RVM installation is being targeted. **Note:** if specified, the user must already exist. |`nil`

## rvm_shell

This resource is a wrapper for the `script` resource which wraps the code block
in an RVM-aware environment.. See the Opscode
[script resource][script_resource] page for more details.

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
ruby_string |An RVM Ruby string that could contain a gemset. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be used. |`"default"`
code        |Quoted script of code to execute. |`nil`
creates     |A file this command creates - if the file exists, the command will not be run. |`nil`
cwd         |Current working director to run the command from. |`nil`
environment |A has of environment variables to set before running this command. |`nil`
group       |A group or group ID that we should change to before running this command. |`nil`
path        |An array of paths to use when searching for the command. |`nil`, uses system path
returns     |The return value of the command (may be an array of accepted values) - this resource raises an exception if the return value(s) do not match. |`0`
timeout     |How many seconds to let the command run before timing out. |`nil`
user        |A user name or user ID that we should change to before running this command. |`nil`
user        |A users's isolated RVM installation on which to apply an action. The default value of `nil` denotes a system-wide RVM installation is being targeted. **Note:** if specified, the user must already exist. |`nil`
umask       |Umask for files created by the command. |`nil`

### Examples

#### Run A Rake Task

    rvm_shell "migrate_rails_database" do
      ruby_string "1.8.7-p352@webapp"
      user        "deploy"
      group       "deploy"
      cwd         "/srv/webapp/current"
      code        %{rake RAILS_ENV=production db:migrate}
    end

## rvm_wrapper

This resource creates a wrapper script for a binary or list of binaries in
a given RVM Ruby (and optional gemset). The given Ruby will be installed if
it isn't already and a gemset will be created in none currently exist.

### Actions

Action    |Description                   |Default
-------|------------------------------|-------
create |Creates one or more wrapper scripts. |Yes

### Attributes

Attribute   |Description |Default value
------------|------------|-------------
prefix      |**Name attribute:** a prefix string for the wrapper script name. |`nil`
ruby_string |An RVM Ruby string that could contain a gemset. If a gemset is given (for example, `"ruby-1.8.7-p330@awesome"`), then it will be used. |`nil`
binary      |A single binary to be wrapped. If this attribute is used do not set values for the `binaries` attribute. |`nil`
binaries    |A list of binaries to be wrapped. If this attribute is used do not set a value for the `binary` attribute. |`nil`
user        |A users's isolated RVM installation on which to apply an action. The default value of `nil` denotes a system-wide RVM installation is being targeted. **Note:** if specified, the user must already exist. |`nil`

**Note:** only `binary` or `binaries` should be used by themselves (never at
the same time).

### Examples

#### Wrapping A Ruby CLI

    rvm_wrapper "sys" do
      ruby_string   "jruby@utils"
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

# Development

* Source hosted at [GitHub][repo]
* Report issues/Questions/Feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every seperate change you make.

# License and Author

Author:: [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>)

Contributors:: https://github.com/fnichol/chef-rvm/contributors

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

[chef_repo]:            https://github.com/opscode/chef-repo
[compilation]:          http://wiki.opscode.com/display/chef/Evaluate+and+Run+Resources+at+Compile+Time
[dragons]:              http://en.wikipedia.org/wiki/Here_be_dragons
[gem_package]:          http://wiki.opscode.com/display/chef/Resources#Resources-Package
[gem_package_options]:  http://wiki.opscode.com/display/chef/Resources#Resources-GemPackageOptions
[gh50]:                 https://github.com/fnichol/chef-rvm/issues/50
[fnichol]:              https://github.com/fnichol
[java_cb]:              http://community.opscode.com/cookbooks/java
[jruby]:                http://jruby.org/
[kgc]:                  https://github.com/websterclay/knife-github-cookbooks#readme
[librarian]:            https://github.com/applicationsonline/librarian#readme
[lwrp]:                 http://wiki.opscode.com/display/chef/Lightweight+Resources+and+Providers+%28LWRP%29
[package_resource]:     http://wiki.opscode.com/display/chef/Resources#Resources-Package
[rvm]:                  http://rvm.beginrescueend.com
[rvm_create_gemset]:    http://rvm.beginrescueend.com/gemsets/creating/
[rvm_delete_gemset]:    http://rvm.beginrescueend.com/gemsets/deleting/
[rvm_empty_gemset]:     http://rvm.beginrescueend.com/gemsets/emptying/
[rvm_default]:          http://rvm.beginrescueend.com/rubies/default/
[rvm_gemsets]:          http://rvm.beginrescueend.com/gemsets/
[rvm_install]:          http://rvm.beginrescueend.com/rubies/installing/
[rvm_remove]:           http://rvm.beginrescueend.com/rubies/removing/
[rvm_stable]:           https://rvm.beginrescueend.com/releases/stable-version.txt
[script_resource]:      http://wiki.opscode.com/display/chef/Resources#Resources-Script
[vagrant]:              http://vagrantup.com

[repo]:         https://github.com/fnichol/chef-rvm
[issues]:       https://github.com/fnichol/chef-rvm/issues
