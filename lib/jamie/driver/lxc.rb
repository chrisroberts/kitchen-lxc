module Jamie

  module Driver

    class SSHBase; end

    class LXC < Jamie::Driver::SSHBase
        
      def perform_create(container, state)
        state["name"] = container + "-1"
        state["hostname"] = "localhost"
      end

    end

  end

end
