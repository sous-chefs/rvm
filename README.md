# RVM Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/rvm.svg)](https://supermarket.chef.io/cookbooks/rvm)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Manages system-wide and per-user [RVM][rvm]s and manages installed Rubies.

## Requirements

- Chef 15.3+

### Platforms

- Debian, Ubuntu
- CentOS, RedHat, Fedora, Scientific, Amazon

### Platform Notes

## Installation

Depending on the situation and use case there are several ways to install
this cookbook. All the methods listed below assume a tagged version release
is the target, but omit the tags to get the head of development. A valid
Chef repository structure like the [Opscode repo][chef_repo] is also assumed.

## Resources

- [rvm_system_install](documentation/rvm_system_install.md)
- [rvm_user_install](documentation/rvm_user_install.md)
- [rvm_ruby](documentation/rvm_ruby.md)
- [rvm_gem](documentation/rvm_gem.md)
- [rvm_gemset](documentation/rvm_gem_set.md)
- [rvm_alias](documentation/rvm_alias.md)
- [rvm_wrapper](documentation/rvm_wrapper.md)

## Contributing

See the CONTRIBUTING.md file
