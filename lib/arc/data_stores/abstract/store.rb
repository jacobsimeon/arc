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
      
      def read query
        case query
        when String
          execute(query).symbolize_keys!
        when Arel::SelectManager
          result_for query
        end
      end
      
      def create stmt
        case stmt
        when String
          execute stmt
        when Arel::InsertManager
          table = stmt.instance_variable_get(:@ast).relation
          execute stmt.to_sql
          projections = schema[table.name.to_sym].column_names.map{ |c| table[c.to_sym] }
          read(
            table.project(*projections).where(
              table.primary_key.eq(
                Arel.sql(last_insert_rowid(table.name, table.primary_key.name).to_s)
              )
            )
          )[0]
        end
      end
      
      def update stmt, id=nil
        case stmt
        when String
          execute stmt
        when Arel::UpdateManager
          execute stmt.to_sql
          if id
            table = stmt.instance_variable_get(:@ast).relation
            projections = schema[table.name.to_sym].column_names.map{ |c| table[c.to_sym] }
            read(
              table.project(*projections)
                .where(table.primary_key.eq id)
            )[0]
          end
        end
      end
      
      def destroy stmt
        case stmt
        when String
          execute stmt
        when Arel::DeleteManager
          execute stmt.to_sql
        end
      end
      
      def last_insert_rowid table_name, pk_name
        'last_insert_rowid()'
      end
          
      def execute query
        #adapters should override this method to execute a query against the database
        #the methods should return an array-like object of hash-like objects
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
