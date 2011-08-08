require 'monitor.rb'

module Arc
  class ConnectionPool    
  
    def initialize(config)
      extend MonitorMixin
      @connections = []
      @checked_out = {}
      @queue = new_cond
      @config = config
      @timeout = config[:timeout] || 5
      @max_connections = config[:max_connections] || 5
    end
        
    def connection
      clear_stale_connections!
      @checked_out[Thread.current.object_id] ||= check_out
    end    
    
    private
    def clear_stale_connections!
      #find all currenly live threads and
      alive = Thread.list.find_all { |t|
        t.alive?
      }.map { |thread| thread.object_id }
      dead = @checked_out.keys - alive
      dead.each do |thread|
        check_in thread
      end      
    end
    
    def connection_available?
      @checked_out.size < @connections.size
    end
    
    def can_create_new?
      @connections.size < @max_connections
    end
    
    def check_out
      # Checkout an available connection
      get_conn = Proc.new do
        conn = if connection_available?
          existing_connection
        elsif can_create_new?
          new_connection
        end
        return conn if conn
      end
          
      synchronize do
        get_conn.call
        @queue.wait(@timeout)
        get_conn.call
      end      
    end      

    def check_in(thread_id)
      conn = @checked_out.delete(thread_id)
      unless conn.nil?
        conn.disconnect!
      end
    end
    
    def new_connection
      puts "new connection"
      c = Connection.new(@config)
      @connections << c
      return c
    end
    
    def existing_connection
      puts "use existing"
      connection = (@connections - @checked_out.values).first
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
