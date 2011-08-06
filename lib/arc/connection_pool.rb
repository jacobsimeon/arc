module Arc
  class ConnectionPool
    def initialize(config)
      #inspect config for adapter information
      #handle creation, check in and check out of connections
    end
    
    def check_in
    end
    
    def create_connection
      #inspect config for adapter
      #generate adapter connection object
    end
    
    def check_out
    end
  end

end
