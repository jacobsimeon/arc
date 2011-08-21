module Arc
  module DataStores
    class AbstractDataStore < ResourcePool
                        
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
      def execute query
        #adapters should override this method to execute an arbitrary query against the database
        raise NotImplementedError
      end      
      alias :connection :resource
      alias :with_connection :with_resource
      def create_resource
        create_connection
      end
      def create_connection
        raise NotImplementedError
      end           
    end
  end
end
