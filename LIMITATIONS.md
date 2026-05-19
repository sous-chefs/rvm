# Limitations

## Package Availability

RVM installs from the upstream installer script instead of OS package repositories. The cookbook uses platform packages only for RVM prerequisites and Ruby build dependencies.

### APT (Debian/Ubuntu)

* Debian 12 and 13: supported for prerequisite and Ruby build dependency packages.
* Ubuntu 22.04 and 24.04: supported for prerequisite and Ruby build dependency packages.

### DNF/YUM (RHEL family)

* AlmaLinux 8, 9, and 10: supported for prerequisite and Ruby build dependency packages.
* Amazon Linux 2023: supported for prerequisite and Ruby build dependency packages.
* CentOS Stream 9 and 10: supported for prerequisite and Ruby build dependency packages.
* Oracle Linux 8 and 9: supported for prerequisite and Ruby build dependency packages.
* Rocky Linux 8, 9, and 10: supported for prerequisite and Ruby build dependency packages.
* Fedora latest: supported for prerequisite and Ruby build dependency packages.

### Zypper (SUSE)

* The cookbook has helper logic for SUSE package names, but SUSE is not included in the current tested support matrix.

## Architecture Limitations

RVM compiles Ruby interpreters from source unless upstream binaries are available for the requested Ruby and platform. Architecture support therefore depends on the requested Ruby version and the platform's compiler toolchain.

## Source/Compiled Installation

RVM's upstream documentation lists `bash`, `curl`, `gpg2`, and GNU userland tools as core installer requirements. The cookbook installs GPG tooling plus additional build dependencies by platform family before invoking the RVM installer.

| Platform Family    | Packages                                                                                                                                                                                                   |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Debian             | `bash`, `curl`, `git-core`, `tar`, `bzip2`, `gzip`, `build-essential`, `libffi-dev`, `libreadline-dev`, `libsqlite3-dev`, `libssl-dev`, `libyaml-dev`, `zlib1g-dev`                                        |
| RHEL/Fedora/Amazon | `bash`, `git`, `tar`, `bzip2`, `gzip`, `autoconf`, `automake`, `bison`, `gcc-c++`, `libffi-devel`, `libtool`, `readline-devel`, `sqlite-devel`, `zlib-devel`, `openssl-devel`                              |
| SUSE               | `bash`, `curl`, `git`, `tar`, `bzip2`, `gzip`, `autoconf`, `automake`, `bison`, `gcc-c++`, `libffi-devel`, `libtool`, `readline-devel`, `sqlite3-devel`, `zlib-devel`, `libyaml-devel`, `libopenssl-devel` |

## Known Issues

* RVM requires Bash and is intended for Unix-like environments. Windows is not supported by this cookbook.
* Ruby compilation can fail when the requested Ruby version does not support the platform OpenSSL, compiler, or architecture.
* Ubuntu 20.04, Debian 11, CentOS Linux, CentOS Stream 8, and Scientific Linux were removed from the support matrix because they are end-of-life for this migration window.
