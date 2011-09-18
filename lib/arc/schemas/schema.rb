module Arc
  module Schemas
    
    class SchemaObject
      attr_reader :name
      def initialize data_store, name=nil
        @items = {}
        @data_store = data_store
        @name = name
      end
      def [] name
        @items[name] ||= fetch_item(name)
      end
      def item_names
        @names ||= fetch_item_names
      end
      def fetch_item_names
        raise NotImplementedError
      end
      def fetch_item name
        raise NotImplementedError
      end
    end
    
    
    class Schema < SchemaObject
      alias :table_names :item_names

      class Table < SchemaObject
        alias :column_names :item_names

        class Column
          attr_reader :name
          attr_reader :allows_null
          attr_reader :default
          def initialize store, properties={}
            @data_store = store
            @name = properties.delete :name
            @allows_null = properties.delete :allows_null
            @default = properties.delete :default
            @is_pk = properties.delete(:pk) || properties.delete(:primary_key)
            @stype = properties.delete(:type)
          end
          def pk?; @is_pk; end
          alias :primary_key? :pk?
          def type
            raise NotImplementedError
          end
        end
      end      
    end
  end
end
