# rvm_gemset

Manages an RVM gemset for a Ruby version.

## Actions

| Action    | Description                  |
| --------- | ---------------------------- |
| `:create` | Creates the gemset (default) |
| `:delete` | Deletes the gemset           |
| `:empty`  | Empties the gemset           |

## Properties

| Property      | Type   | Default       | Description                                            |
| ------------- | ------ | ------------- | ------------------------------------------------------ |
| `gemset`      | String | Name property | Gemset name                                            |
| `ruby_string` | String | Required      | Ruby version for the gemset                            |
| `user`        | String | `nil`         | User RVM installation to manage; system RVM when unset |

## Examples

```ruby
rvm_gemset 'app' do
  ruby_string 'ruby-3.2.0'
end
```
