# Migration

## From Attributes to Resources

This release removes the legacy `attributes/` API. RVM is now configured entirely through custom resource properties.

### Removed Attribute Defaults

The following node attributes no longer exist:

* `node['rvm']['default_ruby']`
* `node['rvm']['user_default_ruby']`
* `node['rvm']['rubies']`
* `node['rvm']['user_rubies']`
* `node['rvm']['global_gems']`
* `node['rvm']['user_global_gems']`
* `node['rvm']['gems']`
* `node['rvm']['user_gems']`
* `node['rvm']['rvmrc_env']`
* `node['rvm']['installs']`
* `node['rvm']['installer_url']`
* `node['rvm']['version']`
* `node['rvm']['autolib_mode']`
* `node['rvm']['root_path']`
* `node['rvm']['install_pkgs']`
* `node['rvm']['gem_package']['rvm_string']`
* `node['rvm']['vagrant']['system_chef_client']`
* `node['rvm']['vagrant']['system_chef_solo']`

### Resource Examples

Install RVM system-wide:

```ruby
rvm_system_install 'system' do
  version 'stable'
  autolib_mode 3
end
```

Install RVM for a user:

```ruby
rvm_user_install 'deploy' do
  home_dir '/home/deploy'
  version 'stable'
end
```

Install and select a Ruby:

```ruby
rvm_ruby 'ruby-3.2.0' do
  default true
end
```

Install a gem for a Ruby:

```ruby
rvm_gem 'bundler' do
  ruby_string 'ruby-3.2.0'
end
```
