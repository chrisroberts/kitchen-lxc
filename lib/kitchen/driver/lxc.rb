require "securerandom"
require "kitchen"

module Kitchen

  module Driver

    class Lxc < Kitchen::Driver::SSHBase

      no_parallel_for :create

      default_config :use_sudo,        true
      default_config :dhcp_lease_file, "/var/lib/misc/dnsmasq.leases"
      default_config :port,            "22"
      default_config :username,        "root" # most LXC templates use this
      default_config :password,        "root" # most LXC templates use this

      def create(state)
        state[:container_id] = instance.name + "-" + ::SecureRandom.hex(3)
        start_container(state)
        if @config[:ipaddress].nil?
          state[:hostname] = container_ip(state)
        else
          state[:hostname] = state[:container_id]
        end
        wait_for_sshd(container_ip(state))
      end

      def destroy(state)
        if state[:container_id]
          destroy_container(state)
        end
      end

      def login_command(state)
        combined = config.merge(state)
        args  = %W{ -o UserKnownHostsFile=/dev/null }
        args += %W{ -o StrictHostKeyChecking=no }
        args += %W{ -o LogLevel=#{logger.debug? ? "VERBOSE" : "ERROR"} }
        args += %W{ -i #{combined[:ssh_key]}} if combined[:ssh_key]
        args += %W{ -p #{combined[:port]}} if combined[:port]
        args += %W{ #{combined[:username]}@#{state[:ipaddress]}}
#        args += %W{ -p #{co}} if @combined[:password]
        Driver::LoginCommand.new(["ssh", *args])
      end

      protected

      def build_ssh_args(state)
        combined = config.merge(state)

        opts = Hash.new
        opts[:user_known_hosts_file] = "/dev/null"
        opts[:paranoid] = false
        opts[:password] = combined[:password] if combined[:password]
        opts[:port] = combined[:port] if combined[:port]
        opts[:keys] = Array(combined[:ssh_key]) if combined[:ssh_key]

        [combined[:ipaddress], combined[:username], opts]
      end

      def start_container(state)
        cmd = "lxc-awesome-ephemeral -d -o #{config[:base_container]} -n #{state[:container_id]}"
        [ :ipaddress, :netmask, :gateway ].each do |opt|
          unless @config[opt].nil?
            cmd << " --#{opt} #{@config[opt]} "
          end
        end
        cmd << " 2>&1 > /dev/null"
        run_command(cmd)
        run_command("lxc-wait -n #{state[:container_id]} -s RUNNING")
      end

      def destroy_container(state)
        run_command("lxc-stop -n #{state[:container_id]}")
      end

      def container_ip(state)
        if !state[:ipaddress].nil?
          return state[:ipaddress]
        elsif !@config[:ipaddress].nil?
          state[:ipaddress] = @config[:ipaddress]
          return state[:ipaddress]
        elsif ::File.exists?(config[:dhcp_lease_file])
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

    class LXC < Lxc; end

  end

end
