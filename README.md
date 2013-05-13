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
- name: ubuntu_1204
  driver_config:
    base_container: ubuntu_1204 # your base container name
    username: kitchen # defaults to "root"
    password: kitchen # defaults to "root"
```

```
$ bundle exec kitchen create
-----> Starting Kitchen
-----> Creating <default-ubuntu>
       [kitchen::driver::lxc command] BEGIN (lxc-awesome-ephemeral -d -o tk-ubuntu-1204 -n default-ubuntu-a0c75e)
       Setting up ephemeral container...
       Starting up the container...
       default-ubuntu-a0c75e is running
       You connect with the command:
           sudo lxc-console -n default-ubuntu-a0c75e
       [kitchen::driver::lxc command] END (0m1.92s)
       Finished creating <default-ubuntu> (0m4.98s).
-----> Creating <stack-ubuntu>
       [kitchen::driver::lxc command] BEGIN (lxc-awesome-ephemeral -d -o tk-ubuntu-1204 -n stack-ubuntu-cb87c2)
       Setting up ephemeral container...
       Starting up the container...
       stack-ubuntu-cb87c2 is running
       You connect with the command:
           sudo lxc-console -n stack-ubuntu-cb87c2
       [kitchen::driver::lxc command] END (0m1.91s)
       Finished creating <stack-ubuntu> (0m4.99s).
-----> Kitchen is finished. (0m9.99s)
$ bundle exec kitchen destroy
-----> Starting Kitchen
-----> Destroying <default-ubuntu>
       [kitchen::driver::lxc command] BEGIN (lxc-awesome-ephemeral -c -o tk-ubuntu-1204 -n default-ubuntu-a0c75e)
       [kitchen::driver::lxc command] END (0m3.41s)
       Finished destroying <default-ubuntu> (0m3.48s).
-----> Destroying <stack-ubuntu>
       [kitchen::driver::lxc command] BEGIN (lxc-awesome-ephemeral -c -o tk-ubuntu-1204 -n stack-ubuntu-cb87c2)
       [kitchen::driver::lxc command] END (0m3.44s)
       Finished destroying <stack-ubuntu> (0m3.52s).
-----> Kitchen is finished. (0m7.03s)
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
