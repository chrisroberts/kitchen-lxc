# Kitchen LXC

The LXC driver for the Chef convergence integration test harness,
[Test Kitchen](https://github.com/test-kitchen).

Kitchen LXC creates an ephemeral clone of a "base" LXC container to
run a test suite.

You may want to use the
[Docker driver](https://github.com/portertech/kitchen-docker).

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

#### port
The SSH port used to login to the container.

Defaults to 22.

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
