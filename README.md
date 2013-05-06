# Kitchen LXC

The LXC driver for the Chef convergence integration test harness, [Test Kitchen](https://github.com/opscode/test-kitchen/tree/1.0).

## Installation

Add this line to your Chef cookbook's Gemfile:

    gem 'kitchen-lxc'

And then execute:

    $ bundle install

## Usage

The kitchen-lxc driver provides several configuration options

* base_container: a base distribution that your platform will be a
  clone of
* username: username you will use to login to the container
* password: password that you will use to login to the container
* ipaddress: ipaddress for the container, currently only values in the
  subnet 10.0.3.0/24 subnet are supported. If no ipaddress is
  specified, dhcp will be used. 
* overlay: directory to store the ephemeral container in, defaults to
  /tmp. If you want to boot containers quickly, you want this
  directory and the one containing it to be on a btrfs or lvm volume.

### Configuration

`.kitchen.local.yml`

```
---
driver_plugin: lxc

platforms:
- name: distribution-release
  driver_config:
    base_container: distribution-release # your base container name
    username: foo # defaults to "root"
    password: bar # defaults to "root"
    ipaddress: 10.0.3.100
    overlay: /var/lib/lxc/overlay   # useful if you want to use a
                                      btrfs or lvm volume
```

### Example

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

Author:: Sean Porter  
Author:: Bryan W. Berry (<bryan.berry@gmail.com>)  

See LICENSE.txt for licensing details


