module Arc
  module DataStores
    class AbstractDataStore
      
      def create_connection
        rand
      end
      
      def initialize config
        @config = config
        @pool = ConnectionPool.new config, do
          create_connection
        end
      end
    
      def to_h
        #contains a hash for each table with an array of column names and column objects
        #ex:
        # {
        #   :users => {
        #     :id => id_column,
        #     :name => name_column
        #   },
        #   :products => {
        #     :id => id_column,
        #     :price => price_column
        #   }
        # } 
      end
      alias :to_hash :to_h
            
      def primary_key name
        #get the primary key column object for the passed table name
      end
    
      def table_exists? name
        #true if the table exists in the database
      end
    
      def tables
        #an array of tables in the data store
      end
    
      def quote_table_name name
        #wrap a table name in quotes
      end

      def quote_column_name name
        #wrap a column name in quotes
      end

      def quote thing, column = nil
        #return the passed value as a string
        #should wrap in proper quotes based on data type
      end
    
      def create query
        #add new data
      end
    
      def read query
        #read existing data
      end
    
      def update query
        #update existing data
      end
    
      def destroy query
        #destroy existing data
      end
          
      private
      def with_connection
        yield @pool.connection
        @pool.checkin
      end

      def execute query
        with_connection do |connection|
          connection.execute query
        end
      end
    
    end
  end
end
