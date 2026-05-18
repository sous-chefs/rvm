# rvm_alias

Manages an RVM alias for a system or user RVM installation.

## Actions

| Action    | Description                            |
| --------- | -------------------------------------- |
| `:create` | Creates or updates the alias (default) |
| `:delete` | Deletes the alias                      |

## Properties

| Property      | Type   | Default       | Description                                            |
| ------------- | ------ | ------------- | ------------------------------------------------------ |
| `alias_name`  | String | Name property | Alias to manage                                        |
| `ruby_string` | String | Required      | Ruby version the alias points to                       |
| `user`        | String | `nil`         | User RVM installation to manage; system RVM when unset |

## Examples

```ruby
rvm_alias 'default' do
  ruby_string 'ruby-3.2.0'
end
```
