# rvm_ruby

Installs or removes a Ruby version from an RVM installation.

## Actions

| Action       | Description                         |
| ------------ | ----------------------------------- |
| `:install`   | Installs the Ruby version (default) |
| `:uninstall` | Removes the Ruby version            |

## Properties

| Property      | Type    | Default       | Description                                            |
| ------------- | ------- | ------------- | ------------------------------------------------------ |
| `ruby_string` | String  | Name property | Ruby version to install                                |
| `default`     | Boolean | `false`       | Set this Ruby as the default alias                     |
| `patch`       | String  | `nil`         | Patch argument passed to `rvm install`                 |
| `user`        | String  | `nil`         | User RVM installation to manage; system RVM when unset |

## Examples

```ruby
rvm_ruby 'ruby-3.2.0' do
  default true
end
```
