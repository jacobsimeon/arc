module Arc
  class ConnectionHandler
    
    def self.add_connection(config, klass=Object)
      connections[klass] ||= ConnectionPool.new(config) if connections[klass].nil?
    end
    
    def self.connections
      @@connections ||= {}
    end
    
    def self.with_connection klass=Object
      yield connections[klass].connection
      connections[klass].checkin      
    end
    
    def self.connections
      @@connections ||= {}
    end
        
  end
end