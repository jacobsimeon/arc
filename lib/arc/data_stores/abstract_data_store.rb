require 'arc/data_stores/arel_compatibility'
module Arc
  module DataStores
    class AbstractDataStore < ResourcePool
      include ArelCompatibility
      include Quoting
      
      def schema
        @schema ||= Schemas[@config[:adapter]].new self
      end
      
      def [] table
        schema[table]
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
          
      def execute query
        #adapters should override this method to execute a query against the database
        raise NotImplementedError
      end
      alias :with_store :with_resource
      alias :columns :[]
      private
      #better semantics for a class that deals with 'connections' instead of 'resources'
      def create_connection
        raise NotImplementedError
      end
      def create_resource
        create_connection
      end
    end
  end
end
