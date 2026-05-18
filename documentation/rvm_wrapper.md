# rvm_wrapper

Creates wrapper executables for binaries in an RVM Ruby.

## Actions

| Action    | Description                |
| --------- | -------------------------- |
| `:create` | Creates wrappers (default) |

## Properties

| Property      | Type   | Default                             | Description                                            |
| ------------- | ------ | ----------------------------------- | ------------------------------------------------------ |
| `prefix`      | String | Name property                       | Prefix for wrapper script names                        |
| `ruby_string` | String | Required                            | Ruby version to wrap                                   |
| `binaries`    | Array  | `%w(ruby gem rake erb irb ri rdoc)` | Binaries to wrap                                       |
| `user`        | String | `nil`                               | User RVM installation to manage; system RVM when unset |

## Examples

```ruby
rvm_wrapper 'app' do
  ruby_string 'ruby-3.2.0'
  binaries %w(ruby gem bundle)
end
```
