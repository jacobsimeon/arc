module Arc
  module DataStores
    class AbstractDataStore < ResourcePool
      include Quoting
                        
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
      
      def visitor
        @visitor ||= begin
          Arel::Visitors.for self
        end
      end
      
      private      
      private :with_resource
      def execute query
        #adapters should override this method to execute an arbitrary query against the database
        raise NotImplementedError
      end
      def create_connection
        raise NotImplementedError
      end

      #better semantics for a class that deals with 'connections' instead of 'resources'
      def create_resource; create_connection; end
      alias :connection :resource
      alias :with_connection :with_resource
    end
  end
end
