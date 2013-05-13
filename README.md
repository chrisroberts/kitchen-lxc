# Kitchen LXC

The LXC driver for the Chef convergence integration test harness,
[Test Kitchen](https://github.com/opscode/test-kitchen/tree/1.0).

Kitchen LXC creates a clone of a "base" LXC container to run a test
suite.

## Installation

Add this line to your Chef cookbook's Gemfile:

    gem 'kitchen-lxc'

And then execute:

    $ bundle install

## Usage

### Configuration

#### base_container
The base LXC container to be cloned for each Test Kitchen suite.

#### username
The username used to login to the container.

Defaults to "root".

#### password
The password used to login to the container.

Defaults to "root".

#### dhcp_lease_file
The DHCP lease file used to determine the container IP address.

Defaults to the first match for "/var/lib/misc/dnsmasq*leases".

#### ipaddress
You may specify an IP address for the container, within the
10.0.3.0/24 subnet, instead of using DHCP.

#### port
The SSH port used to login to the container.

Defaults to 22.

#### overlay
The directory to use for the rootfs overlay.

Defaults to "/tmp".

#### device
The size (MB) of the block device for the rootfs overlay.

### Example

`.kitchen.local.yml`

```
---
driver_plugin: lxc

platforms:
- name: ubuntu-1204
  driver_config:
    base_container: ubuntu-1204 # your base container name
    username: kitchen # defaults to "root"
    password: kitchen # defaults to "root"
```

```
$ bundle exec kitchen create
-----> Starting Kitchen
-----> Creating <default-ubuntu>
       [lxc command] BEGIN (sudo lxc-clone -o ubuntu-1204 -n default-ubuntu-a5fb8a)
       Tweaking configuration
       Copying rootfs...
       Updating rootfs...
       'default-ubuntu-a5fb8a' created
       [lxc command] END (0m6.17s)
       [lxc command] BEGIN (sudo lxc-start -n default-ubuntu-a5fb8a -d)
       [lxc command] END (0m0.01s)
       [lxc command] BEGIN (sudo lxc-wait -n default-ubuntu-a5fb8a -s RUNNING)
       [lxc command] END (0m1.05s)
       Finished creating <default-ubuntu> (0m7.42s).
-----> Creating <default-centos>
       [lxc command] BEGIN (sudo lxc-clone -o centos-6 -n default-centos-58fced)
       Tweaking configuration
       Copying rootfs...
       Updating rootfs...
       'default-centos-58fced' created
       [lxc command] END (0m6.68s)
       [lxc command] BEGIN (sudo lxc-start -n default-centos-58fced -d)
       [lxc command] END (0m0.02s)
       [lxc command] BEGIN (sudo lxc-wait -n default-centos-58fced -s RUNNING)
       [lxc command] END (0m1.05s)
       Finished creating <default-centos> (0m13.92s).
-----> Kitchen is finished. (0m21.45s)
$ bundle exec kitchen destroy
-----> Starting Kitchen
-----> Destroying <default-ubuntu>
       [lxc command] BEGIN (sudo lxc-destroy -n default-ubuntu-a5fb8a -f)
       [lxc command] END (0m1.18s)
       Finished destroying <default-ubuntu> (0m1.21s).
-----> Destroying <default-centos>
       [lxc command] BEGIN (sudo lxc-destroy -n default-centos-58fced -f)
       [lxc command] END (0m1.14s)
       Finished destroying <default-centos> (0m1.17s).
-----> Kitchen is finished. (0m2.45s)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

Author:: Sean Porter (<portertech@gmail.com>)
Author:: Bryan W. Berry (<bryan.berry@gmail.com>)

See LICENSE.txt for licensing details
