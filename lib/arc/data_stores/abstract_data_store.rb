module Arc
  module DataStores
    class AbstractDataStore < ResourcePool

      !!!!!!!!!!!!!!!!!!!!
        #include Quoting
        #include Casting
      !!!!!!!!!!!!!!!!!!!!     
      
      def schema
        @schema ||= Schemas[@config[:adapter]].new(self)
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
        #adapters should override this method to execute a query against the database
        raise NotImplementedError
      end
      
      #better semantics for a class that deals with 'connections' instead of 'resources'
      private :with_resource
      def create_connection; raise NotImplementedError; end
      def create_resource; create_connection; end
      alias :connection :resource
      alias :with_connection :with_resource
    end
  end
end
