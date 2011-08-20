require 'monitor.rb'

module Arc
  class ConnectionPool    
    class ResourcePoolTimeoutError < StandardError; end
    
    def initialize config
      extend MonitorMixin
      @connections = []
      @checked_out = {}
      @queue = new_cond
      @config = config
      @timeout = config[:timeout] || 5
      @size = config[:pool] || 5
    end
        
    def connection
      #clear_stale_connections!
      @checked_out[Thread.current.object_id] ||= checkout
    end    
    
    def checkin(thread_id=Thread.current.object_id)
      synchronize do
        @checked_out.delete(thread_id)
        @queue.signal 
      end
    end
    
    def create_resource
      Connections.connection_for @config
    end
    
    private
    def find_resource
      if connection_available?
        find_existing_resource
      elsif can_create_new?
        add_new_resource
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
        resource = find_resource
        return resource unless resource.nil?
        @queue.wait @timeout
        clear_stale_connections!
        raise ResourcePoolTimeoutError unless can_create_new? or connection_available?
      end
      checkout
    end      

    def find_existing_resource
      (@connections - @checked_out.values).first
    end
    
    def add_new_resource
      @connections << r = create_resource; r
    end
    
  end

end
