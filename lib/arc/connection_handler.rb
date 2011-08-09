module Arc
  class ConnectionHandler
    def self.add_connection(klass, config)
      connections[klass] = ConnectionPool.new(config) if connections[klass].nil?
    end
    
    def self.connections
      @@connections ||= {}
    end
    
    def self.connection_for klass
      connections[klass] unless connections[klass].nil?
    end
  end
end