require "securerandom"
require "kitchen"

module Kitchen

  module Driver

    class Lxc < Kitchen::Driver::SSHBase

      no_parallel_for :create
      
      default_config :use_sudo,        true
      default_config :dhcp_lease_file, '/var/lib/misc/dnsmasq.leases'
      default_config :port,            "22"
      default_config :username,        "root" # most LXC templates use this
      default_config :password,        "root" # most LXC templates use this

      def create(state)
        state[:container_id] = instance.name + "-" + ::SecureRandom.hex(3)
        state[:overlay] = @config[:overlay] if @config[:overlay]
        start_container(state)
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
        [ :ipaddress, :netmask, :gateway, :key ].each do |opt|
          unless @config[opt].nil?
            cmd << " --#{opt} #{@config[opt]} "
          end
        end
        cmd << " -z #{state[:overlay]} " if state[:overlay]
        run_command(cmd)
        run_command("lxc-wait -n #{state[:container_id]} -s RUNNING")
      end

      def destroy_container(state)
        cmd = "lxc-awesome-ephemeral -c -o #{config[:base_container]} -n #{state[:container_id]}"
        cmd << " -z #{state[:overlay]} " if state[:overlay]
        run_command(cmd)
      end

      # TODO: parse LXC.conf settings to find actual name of bridge interface
      def find_dhcp_file(lease_file)
        if ::File.exists?(lease_file)
          return lease_file
        else
          lease_files = Dir['/var/lib/misc/dnsmasq.*.leases']
          return lease_files[0] unless lease_files.empty?
        end
        raise ActionFailed, "LXC DHCP lease file does not exist '#{config[:dhcp_lease_file]}' and could not find alternate"
      end

      def container_ip(state)
        if @config[:ipaddress]
          return @config[:ipaddress]
        else
          dhcp_lease_file = find_dhcp_file(config[:dhcp_lease_file])
          30.times do
            leases = ::File.readlines(dhcp_lease_file).map{ |line| line.split(" ") }
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
