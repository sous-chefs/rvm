## 0.7.0 (May 14, 2011)

  * Revamp and update README.md. [GH-3]
  * Add CHANGELOG.md. [GH-5]
  * Attr rvm/upgrade accepts "none", false and nil as same value. [GH-19]
  * Update rvm/install_rubies attr to "true"/"false".
  * Update rvm/skip_docs_on_install attr to rvm/rvm_gem_options.
  * Speed up install by disabling RDOC generation. [GH-13]
  * New experimental recipe gem_package which patches gem_package resource.
  * Add rvm_global_gem resource.
  * Refactor of rvm_gem provider to leverage Chef::Provider::Package::Rubygems.
  * Allow no default RVM ruby (i.e. use system ruby). [GH-14]
  * Update RVM install to use SSL URL. [GH-12]
  * Now /etc/rvmrc has export for rvm/rvmrc key/value pairs.

## Previous

The changelog began with version 0.6.0 so any changes prior to that can be
seen by checking the tagged releases and reading git commit messages.
