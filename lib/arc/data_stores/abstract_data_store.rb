module Arc
  module DataStores
    class AbstractDataStore
      
      def initialize config
        @config = config
      end
            
      def primary_key name
        #get the primary key column object for the passed table name
        raise NotImplementedError        
      end
    
      def table_exists? name
        #true if the table exists in the database
        raise NotImplementedError        
      end
    
      def tables
        #an array of tables in the data store
        raise NotImplementedError        
      end
    
      def quote_table_name name
        #wrap a table name in quotes
        raise NotImplementedError        
      end

      def quote_column_name name
        #wrap a column name in quotes
        raise NotImplementedError        
      end

      def quote thing, column = nil
        #return the passed value as a string
        #should wrap in proper quotes based on data type
        raise NotImplementedError
      end
    
      def create query
        #add new data
        raise NotImplementedError
      end
    
      def read query
        #read existing data
        raise NotImplementedError
      end
    
      def update query
        #update existing data
        raise NotImplementedError
      end
    
      def destroy query
        #destroy existing data
        raise NotImplementedError
      end
          
      private
      def create_connection
        #this is the method that will be called each time the connection pool needs to create a new connection
        raise NotImplementedError
      end
      
      def execute query
        #adapters should override this method to execute an arbitrary query against the database
        raise NotImplementedError
      end          

      def pool
        #a pool of connection objects created by #create_connection
        #the connection pool provides thread safety
        @pool ||= ConnectionPool.new @config, do
          create_connection
        end
      end
      
      def with_connection
        #convenience method to yield a connection object then check it back in
        result = yield pool.connection
        @pool.checkin
        result
      end
      
    end
  end
end
