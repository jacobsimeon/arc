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
      clear_stale_connections!
      @checked_out[Thread.current.object_id] ||= checkout
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
      #find all currenly live threads and
      alive = Thread.list.find_all { |t|
        t.alive?
      }.map { |thread| thread.object_id }
      dead = @checked_out.keys - alive
      dead.each do |thread|
        checkin thread
      end      
    end
    
    def connection_available?
      @checked_out.size < @connections.size
    end
    
    def can_create_new?
      @connections.size < @size
    end
    
    def checkout
      # Checkout an available connection
      cr = Proc.new do
        r = create_resource
        unless r.nil?
          #for some reason tests don't pass without this
          sleep 0
          return r
        end
      end
      
      synchronize do
        cr.call
        #wait for signal or timeout 
        @queue.wait(@timeout)
        cr.call
      end
      
      raise ResourcePoolTimeoutError
    end      

    def checkin(thread_id)
      conn = @checked_out.delete(thread_id)
      synchronize { @queue.signal }
    end
    
    def new_connection
      @connections << c = Connection.new(@config)
      return c
    end
    
    def existing_connection
      (@connections - @checked_out.values).first
    end
    
    
    class Connection
      def initialize(config)
        @free = true
        @config = config
        #inspect config and determine which adapter to use
        #create an instance of the appropriate subclass 
      end
      def disconnect!
        #do whatever you need to do just before this object gets removed from its connection pool
      end
    end
  end

end
