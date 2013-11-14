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
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

See LICENSE.txt for licensing details
