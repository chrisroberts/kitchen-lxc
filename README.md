# Kitchen LXC

The LXC driver for the Chef convergence integration test harness,
[Test Kitchen](https://github.com/test-kitchen).

Kitchen LXC uses ephemeral containers to run a test suite.

You may want to use this instead of the
[Docker driver](https://github.com/portertech/kitchen-docker).

## Installation

Add this line to your Chef cookbook's Gemfile:

    gem 'kitchen-lxc'

And then execute:

    $ bundle install

## Usage

### Configuration

#### lxc_directory
The base LXC container directory on the host.

#### username
The username used to login to the container.

Defaults to "root".

#### password
The password used to login to the container.

Defaults to "root".

#### port
The SSH port used to login to the container.

Defaults to 22.

### System layout

This driver will map the platform name to a container name
with the defined lxc directory. The name is munged with a
simple gsub regex:

```ruby
name.gsub(/[_\-.]/, '')
```

and it will then look for container names that start with
the updated platform name. So, if the platform name is
'ubuntu', and the host system has 'ubuntu_1204' and 'ubuntu_1404',
the container used will be 'ubuntu_1204'

### System setup

An easy way to setup the host machine is to use the `vagabond` cookbook.
It will provide you with a collection of platforms including ubuntu,
centos, and debian. Just copy the `/opt/hw-lxc-config/id_rsa` to the
user's default key. This will remove the need to futz with user/pass
configuration.

### Example

`.kitchen.local.yml`

```
---
driver_plugin: lxc

platforms:
- name: ubuntu
  driver_config:
    username: kitchen # defaults to "root"
    password: kitchen # defaults to "root"
```

```
$ sudo kitchen create default
-----> Starting Kitchen (v1.0.0.beta.4)
-----> Creating <default-ubuntu_1204>
       Finished creating <default-ubuntu_1204> (0m4.50s).
-----> Kitchen is finished. (0m4.54s)
$ sudo kitchen destroy default
-----> Starting Kitchen (v1.0.0.beta.4)
-----> Destroying <default-ubuntu_1204>
       Finished destroying <default-ubuntu_1204> (0m0.32s).
-----> Kitchen is finished. (0m0.35s)
$ sudo kitchen list
Instance        Driver  Provisioner  Last Action
default-ubuntu_1204  Lxc     Chef Solo    <Not Created>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

See LICENSE.txt for licensing details
