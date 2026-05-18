# rvm_user_install

Installs RVM for a single user under that user's home directory.

## Actions

| Action     | Description                 |
| ---------- | --------------------------- |
| `:install` | Installs user RVM (default) |

## Properties

| Property           | Type            | Default                                    | Description                                        |
| ------------------ | --------------- | ------------------------------------------ | -------------------------------------------------- |
| `user`             | String          | Name property                              | User to install RVM for                            |
| `home_dir`         | String          | User home from system lookup               | Home directory for the RVM installation            |
| `gpg_key`          | String          | RVM release keys                           | GPG key fingerprints for installer verification    |
| `keyserver`        | String          | `'hkp://keyserver.ubuntu.com'`             | GPG keyserver                                      |
| `installer_url`    | String          | RVM installer URL                          | Installer script URL                               |
| `version`          | String          | `'stable'`                                 | RVM version to install                             |
| `autolib_mode`     | Integer, String | `3`                                        | RVM autolibs mode                                  |
| `rvmrc_env`        | Hash            | `{ 'rvm_gem_options' => '--no-document' }` | Values rendered to `.rvmrc`                        |
| `install_packages` | Boolean         | `true`                                     | Install prerequisite and build dependency packages |
| `manage_gpg_keys`  | Boolean         | `true`                                     | Install GPG tooling and import RVM keys            |

## Examples

```ruby
rvm_user_install 'deploy' do
  home_dir '/home/deploy'
  version 'stable'
end
```
