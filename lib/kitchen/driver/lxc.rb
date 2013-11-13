require "kitchen"
require "elecksee/ephemeral"

module Kitchen

  module Driver

    class Lxc < Kitchen::Driver::SSHBase

      default_config :username, "root" # most LXC templates use this
      default_config :password, "root" # most LXC templates use this

      no_parallel_for :create

      def create(state)
        state[:container] = ::Lxc::Ephemeral.new(config)
        state[:container].start!(:fork)
        lxc = ::Lxc.new(state[:container].name)
        lxc.wait_for_state(:running)
        state[:hostname] = lxc.container_ip(10, true)
        wait_for_sshd(state[:hostname])
      end

      def destroy(state)
        state[:container].cleanup if state[:container]
      end

    end

    class LXC < Lxc; end

  end
end
