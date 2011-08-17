name             "rvm"
maintainer       "Fletcher Nichol"
maintainer_email "fnichol@nichol.ca"
license          "Apache 2.0"
description      "Installs and manages RVM. Includes several LWRPs."
long_description "Please refer to README.md (it's long)."
version          "0.7.1"

recipe "rvm",               "Includes all recipes"
recipe "rvm::system",       "Installs system-wide RVM"
recipe "rvm::vagrant",      "An optional recipe to help if running in a Vagrant virtual machine"
recipe "rvm::gem_package",  "An experimental recipe that patches the gem_package resource"

%w{ debian ubuntu suse centos redhat fedora mac_os_x }.each do |os|
  supports os
end

# if using jruby, java is required on system
recommends  "java"
