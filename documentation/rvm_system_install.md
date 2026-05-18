# rvm_system_install

Installs RVM system-wide under `/usr/local/rvm`.

## Actions

| Action     | Description                   |
| ---------- | ----------------------------- |
| `:install` | Installs system RVM (default) |

## Properties

| Property           | Type            | Default                                    | Description                                        |
| ------------------ | --------------- | ------------------------------------------ | -------------------------------------------------- |
| `rvm_group_users`  | Array           | `[]`                                       | Users to append to the `rvm` group                 |
| `gpg_key`          | String          | RVM release keys                           | GPG key fingerprints for installer verification    |
| `keyserver`        | String          | `'hkp://keyserver.ubuntu.com'`             | GPG keyserver                                      |
| `installer_url`    | String          | RVM installer URL                          | Installer script URL                               |
| `version`          | String          | `'stable'`                                 | RVM version to install                             |
| `autolib_mode`     | Integer, String | `3`                                        | RVM autolibs mode                                  |
| `rvmrc_env`        | Hash            | `{ 'rvm_gem_options' => '--no-document' }` | Values rendered to `/etc/rvmrc`                    |
| `install_packages` | Boolean         | `true`                                     | Install prerequisite and build dependency packages |
| `manage_gpg_keys`  | Boolean         | `true`                                     | Install GPG tooling and import RVM keys            |

## Examples

```ruby
rvm_system_install 'system' do
  version 'stable'
  rvm_group_users ['deploy']
end
```
