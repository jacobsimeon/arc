require 'arc/data_stores/abstract/arel_compatibility'
require 'arc/data_stores/abstract/object_definitions'
require 'arc/quoting'
require 'arc/casting'

module Arc
  module DataStores
    class AbstractDataStore < ResourcePool
      include ArelCompatibility
      include Arc::Quoting
      include Arc::Casting
            
      def [] table
        schema[table]
      end

      def schema
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
          
      def execute query
        #adapters should override this method to execute a query against the database
        raise NotImplementedError
      end
      alias :with_store :with_resource
      alias :columns :[]
      
      def type_mappings_for query
        type_mappings = {}
        query.instance_variable_get(:@ctx).projections.each do |projection|
          is_alias = projection.respond_to?(:right)
          relation = is_alias ? projection.left.relation : projection.relation

          root_projection = is_alias ? projection.left : projection
          relation_is_alias = root_projection.relation.respond_to?(:left)

          root_relation = relation_is_alias ? relation.left : relation

          table_name = root_relation.name
          result_column_name = is_alias ? projection.right.to_sym : projection.name
          table_column_name = root_projection.name

          table = Arel::Table.engine[table_name.to_sym]
          column = table[table_column_name.to_sym]

          type_mappings[result_column_name] = column.type.to_sym
        end
        type_mappings
      end
      
      def result_for query
        mappings = type_mappings_for query
        rows = read(query.to_sql)
        return Array.new(rows.size) do |index|
          Hash.new do |hash, key|
            hash[key] = cast rows[index][key], mappings[key]
          end
        end
      end
      
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
