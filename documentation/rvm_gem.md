# rvm_gem

Manages a gem inside an RVM Ruby and optional gemset.

## Actions

| Action     | Description                |
| ---------- | -------------------------- |
| `:install` | Installs the gem (default) |
| `:remove`  | Removes the gem            |
| `:upgrade` | Updates the gem            |

## Properties

| Property       | Type   | Default       | Description                                            |
| -------------- | ------ | ------------- | ------------------------------------------------------ |
| `package_name` | String | Name property | Gem name                                               |
| `version`      | String | `nil`         | Gem version to install                                 |
| `ruby_string`  | String | `'default'`   | RVM Ruby to use                                        |
| `gemset`       | String | `nil`         | Gemset to install into                                 |
| `source`       | String | `nil`         | Custom gem source                                      |
| `options`      | String | `nil`         | Additional command options                             |
| `user`         | String | `nil`         | User RVM installation to manage; system RVM when unset |

## Examples

```ruby
rvm_gem 'bundler' do
  ruby_string 'ruby-3.2.0'
end
```
