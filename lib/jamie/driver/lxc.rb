require "securerandom"
require "mixlib/shellout"

module Jamie

  class Instance
    attr_accessor :name
  end

  module Driver

    class SSHBase
      def config
        {
          "use_sudo" => true,
          "dhcp_lease_file" => "/var/lib/misc/dnsmasq.leases"
        }
      end
    end

    class LXC < Jamie::Driver::SSHBase

      def perform_create(instance, state)
        state["name"] = instance.name + "-" + ::SecureRandom.hex(3)
        clone_container(instance, state)
        start_container(instance, state)
        state["hostname"] = container_ip(instance, state)
      end

      def perform_destroy(instance, state)
        destroy_container(instance, state)
      end

      protected

      def run_command(command)
        if config["use_sudo"]
          command = "sudo " + command
        end
        puts "       [lxc command] '#{command}'"
        shell = Mixlib::ShellOut.new(command, :live_stream => STDOUT, :timeout => 60000)
        shell.run_command
        puts "       [lxc command] ran in #{shell.execution_time} seconds."
        shell.error!
      rescue Mixlib::ShellOut::ShellCommandFailed => error
        raise ActionFailed, error.message
      end

      def clone_container(instance, state)
        run_command("lxc-clone -o #{instance.name} -n #{state["name"]}")
      end

      def start_container(instance, state)
        run_command("lxc-start -n #{state["name"]} -d")
        run_command("lxc-wait -n #{state["name"]} -s RUNNING")
      end

      def destroy_container(instance, state)
        run_command("lxc-destroy -n #{state["name"]} -f")
      end

      def container_ip(instance, state)
        if File.exists?(config["dhcp_lease_file"])
          3.times do
            leases = File.readlines(config["dhcp_lease_file"]).map{ |line| line.split(" ") }
            leases.each do |lease|
              if lease.include?(state["name"])
                return lease[2]
              end
            end
            sleep 3
          end
        else
          raise ActionFailed, "LXC DHCP lease file does not exist '#{config["dhcp_lease_file"]}'"
        end
        raise ActionFailed, "Could not determine IP address for LXC container '#{state["name"]}'"
      end

    end

  end

end
