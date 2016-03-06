# <a name="title"></a> chef-rvm [![Build Status](https://secure.travis-ci.org/martinisoft/chef-rvm.png?branch=master)](http://travis-ci.org/martinisoft/chef-rvm)

## WARNING - Please read!

There is currently a _major_ rewrite going on with this cookbook to simply
the interface to RVM with Chef. Expect the master branch to be very broken
until there is a 1.0 release. All previous pull requests will need to rebase
to the newer master to contribute to the new [Resource][resource-blog] based
cookbook.

## <a name="description"></a> Description

Manages system-wide and per-user [RVM][rvm]s and manages installed Rubies.
Several resources are defined to accomplish these tasks.

## <a name="requirements"></a> Requirements

### <a name="requirements-chef"></a> Chef

Tested on 12.5.1 but older versions of chef may not work due to the changes
in the resource model. You are welcome to submit a pull request to add this
support.

File an [issue][issues] if this isn't the case.

### <a name="requirements-platform"></a> Platform

The following platforms have been tested with this cookbook, meaning that
the recipes and LWRPs run on these platforms without error:

* ubuntu (12.04 and higher)
* debian (6.0 and newer)
* mac_os_x (10.6/10.7) (See [Platform Notes](#platform-notes-osx))
* mac_os_x_server (See [Platform Notes](#platform-notes-osx))
* suse (openSUSE, SLES)
* centos
* amazon (2011.09)
* scientific
* redhat
* fedora
* gentoo

Please [report][issues] any additional platforms so they can be added.

### Platform Notes

#### <a name="platform-notes-osx"></a> OSX

This cookbook suggests the [homebrew](http://community.opscode.com/cookbooks/homebrew) cookbook, which is needed to install
any additional packages needed to compile ruby. RVM now ships binary rubies,
but will require homebrew to install any additional libraries.

### <a name="requirements-cookbooks"></a> Cookbooks

If you are installing [JRuby][jruby] then a Java runtime will need to be
installed. The Opscode [java cookbook][java_cb] can be used on supported
platforms.

## <a name="installation"></a> Installation

Depending on the situation and use case there are several ways to install
this cookbook. All the methods listed below assume a tagged version release
is the target, but omit the tags to get the head of development. A valid
Chef repository structure like the [Opscode repo][chef_repo] is also assumed.

### <a name="installation-berkshelf"></a> Using Berkshelf

[Berkshelf][berkshelf] is a way to manage a cookbook or an application's
cookbook dependencies. Include the cookbook in your Berksfile, and then run
`berks install`. To install using Berkshelf:

    gem install berkshelf
    cd chef-repo
    berks init
    echo "cookbook 'rvm', github: 'fnichol/chef-rvm'" >> Berksfile
    berks install

### <a name="installation-librarian"></a> Using Librarian-Chef

[Librarian-Chef][librarian] is a bundler for your Chef cookbooks.
Include a reference to the cookbook in a [Cheffile][cheffile] and run
`librarian-chef install`. To install Librarian-Chef:

    gem install librarian-chef
    cd chef-repo
    librarian-chef init
    cat >> Cheffile <<END_OF_CHEFFILE
    cookbook 'rvm',
      :git => 'git://github.com/fnichol/chef-rvm.git', :ref => 'v0.10.1'
    END_OF_CHEFFILE
    librarian-chef install

## <a name="recipes"></a> Recipes

### <a name="recipes-default"></a> default

Installs the RVM gem and initializes Chef to use the Resources in this cookbook
for installing and managing RVM.

## <a name="contributing"></a> Contributing

See the CONTRIBUTING.md file

### Testing

Make sure you have the following requirements setup:

* [Vagrant][vagrant]
* [vagrant-berkshelf][vagrant-berkshelf]

After you `bundle install` run `rake` for unit tests and `kitchen test` for
integration level tests.

## <a name="license"></a> License and Authors

Authors:: [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>)
          [Aaron Kalin][martinisoft] (<akalin@martinisoftware.com>)

Contributors:: https://github.com/martinisoft/chef-rvm/contributors

Copyright:: 2010 - 2016, Fletcher Nichol and Aaron Kalin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[berkshelf]:            http://berkshelf.com
[chef_repo]:            https://github.com/chef/chef
[cheffile]:             https://github.com/applicationsonline/librarian/blob/master/lib/librarian/chef/templates/Cheffile
[compilation]:          http://wiki.opscode.com/display/chef/Evaluate+and+Run+Resources+at+Compile+Time
[dragons]:              http://en.wikipedia.org/wiki/Here_be_dragons
[fnichol]:              https://github.com/fnichol
[martinisoft]:          https://github.com/martinisoft
[java_cb]:              http://supermarket.chef.io/cookbooks/java
[jruby]:                http://jruby.org/
[librarian]:            https://github.com/applicationsonline/librarian#readme
[rvm]:                  https://rvm.io
[rvm_create_gemset]:    https://rvm.io/gemsets/creating/
[rvm_delete_gemset]:    https://rvm.io/gemsets/deleting/
[rvm_empty_gemset]:     https://rvm.io/gemsets/emptying/
[rvm_default]:          https://rvm.io/rubies/default/
[rvm_gemsets]:          https://rvm.io/gemsets/
[rvm_install]:          https://rvm.io/rvm/install/
[rvm_remove]:           https://rvm.io/rubies/removing/
[rvm_ruby_install]:     https://rvm.io/rubies/installing/
[rvm_upgrading]:        https://rvm.io/rvm/upgrading/
[vagrant]:              http://vagrantup.com
[vagrant-berkshelf]:    https://github.com/berkshelf/vagrant-berkshelf
[resource-blog]:        https://www.chef.io/blog/2015/10/08/chef-client-12-5-released/

[repo]:         https://github.com/martinisoft/chef-rvm
[issues]:       https://github.com/martinisoft/chef-rvm/issues
