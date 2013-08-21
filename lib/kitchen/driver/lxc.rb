require "securerandom"
require "kitchen"

module Kitchen

  module Driver

    class Lxc < Kitchen::Driver::SSHBase

      no_parallel_for :create

      default_config :use_sudo,        false
      default_config :dhcp_lease_file, Dir["/var/lib/misc/dnsmasq*leases"][0]
      default_config :port,            "22"
      default_config :username,        "root" # most LXC templates use this
      default_config :password,        "root" # most LXC templates use this
      default_config :use_ephemeral,   true

      def create(state)
        state[:container_id] = instance.name + "-" + ::SecureRandom.hex(3)
        state[:overlay] = config[:overlay] if config[:overlay]
        if config[:use_ephemeral]
          start_ephemeral(state)
        else
          start_clone(state)
        end
        state[:hostname] = container_ip(state)
        wait_for_sshd(state[:hostname])
      end

      def destroy(state)
        return unless state[:container_id]
        if config[:use_ephemeral]
          destroy_ephemeral(state)
        else
          destroy_clone(state)
        end
      end

      protected

      def start_clone(state)
        run_command("lxc-clone -o #{config[:base_container]} -n #{state[:container_id]}")
        run_command("lxc-start -n #{state[:container_id]} -d")
        run_command("lxc-wait -n #{state[:container_id]} -s RUNNING")
      end

      def destroy_clone(state)
        run_command("lxc-destroy -n #{state[:container_id]} -f")
      end

      def start_ephemeral(state)
        cmd = "lxc-awesome-ephemeral -d -o #{config[:base_container]} -n #{state[:container_id]}"
        [:device, :ipaddress, :netmask, :gateway, :key].each do |opt|
          unless config[opt].nil?
            cmd << " --#{opt} #{config[opt]}"
          end
        end
        cmd << " -z #{state[:overlay]}" if state[:overlay]
        run_command(cmd)
      end

      def destroy_ephemeral(state)
        cmd = "lxc-awesome-ephemeral -c -o #{config[:base_container]} -n #{state[:container_id]}"
        cmd << " -z #{state[:overlay]}" if state[:overlay]
        run_command(cmd)
      end

      def dhcp_lease_file
        unless ::File.exists?(config[:dhcp_lease_file])
          raise ActionFailed, "LXC DHCP lease file does not exist '#{config[:dhcp_lease_file]}'"
        end
        config[:dhcp_lease_file]
      end

      def container_ip(state)
        if config[:ipaddress]
          return config[:ipaddress]
        else
          30.times do
            leases = ::File.readlines(dhcp_lease_file).map { |line| line.split(" ") }
            leases.each do |lease|
              return lease[2] if lease.include?(state[:container_id])
            end
            sleep 3
          end
        end
        raise ActionFailed, "Could not determine IP address for LXC container '#{state[:container_id]}'"
      end
    end

    class LXC < Lxc; end

  end
end
