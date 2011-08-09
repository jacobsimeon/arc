require 'monitor.rb'

module Arc
  class ConnectionPool    
    class ResourcePoolTimeoutError < StandardError; end
    
    def initialize(config)
      extend MonitorMixin
      @connections = []
      @checked_out = {}
      @queue = new_cond
      @config = config
      @timeout = config[:timeout] || 5
      @size = config[:size] || 5
    end
        
    def connection
      #clear_stale_connections!
      @checked_out[Thread.current.object_id] ||= checkout
    end    
    
    def checkin(thread_id)
      synchronize do
        @checked_out.delete(thread_id)
        @queue.signal 
      end
    end
        
    private
    def create_resource
      if connection_available?
        existing_connection
      elsif can_create_new?
        new_connection
      end      
    end
    
    def clear_stale_connections!
      #find all currenly live threads and check in their corresponding connections
      alive = Thread.list.find_all { |t| t.alive? }.map { |thread| thread.object_id }
      dead = @checked_out.keys - alive
      dead.each { |t| checkin t }
    end
    
    def connection_available?
      @checked_out.keys.size < @connections.size
    end
    
    def can_create_new?
      @connections.size < @size
    end
    
    def checkout
      #Checkout an available connection or create a new one
      synchronize do
        resource = create_resource
        return resource unless resource.nil?
        @queue.wait @timeout
        clear_stale_connections!
      end
      return checkout if can_create_new? || connection_available?
      raise ResourcePoolTimeoutError
    end      

    def new_connection
      @connections << c = Connection.new(@config) and c
    end
    
    def existing_connection
      (@connections - @checked_out.values).first
    end
        
    class Connection; end
    
  end

end
