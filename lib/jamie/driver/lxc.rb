require "securerandom"
require "jamie"

module Jamie

  module Driver

    class Lxc < Jamie::Driver::SSHBase

      default_config :use_sudo,         true
      default_config :dhcp_lease_file,  "/var/lib/misc/dnsmasq.leases"
      default_config :port,             "22"
      default_config :username,         "jamie"
      default_config :password,         "jamie"

      def create(state)
        state[:container_id] = instance.name + "-" + ::SecureRandom.hex(3)
        clone_container(state)
        start_container(state)
        state[:hostname] = container_ip(state)
        wait_for_sshd(state[:hostname])
      end

      def destroy(state)
        if state[:container_id]
          destroy_container(state)
        end
      end

      protected

      def clone_container(state)
        run_command("lxc-clone -o #{config[:base_container]} -n #{state[:container_id]}")
      end

      def start_container(state)
        run_command("lxc-start -n #{state[:container_id]} -d")
        run_command("lxc-wait -n #{state[:container_id]} -s RUNNING")
      end

      def destroy_container(state)
        run_command("lxc-destroy -n #{state[:container_id]} -f")
      end

      def container_ip(state)
        if ::File.exists?(config[:dhcp_lease_file])
          30.times do
            leases = ::File.readlines(config[:dhcp_lease_file]).map{ |line| line.split(" ") }
            leases.each do |lease|
              if lease.include?(state[:container_id])
                return lease[2]
              end
            end
            sleep 3
          end
        else
          raise ActionFailed, "LXC DHCP lease file does not exist '#{config[:dhcp_lease_file]}'"
        end
        raise ActionFailed, "Could not determine IP address for LXC container '#{state[:container_id]}'"
      end

    end

  end

end
