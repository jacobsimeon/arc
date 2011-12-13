require 'q/collector'
module Arc
  module DataStores
    module ObjectDefinitions

      class Schema
        include Collector
        alias :table_names :keys
        def initialize store
          @data_store = store
        end
        def execute_ddl ddl
          case ddl
          when Array
            ddl.each { |s| @data_store.execute s }            
          when String
            execute_ddl ddl.split(';')
          end        
        end
      end
    
      class Table
        include Collector
        alias :column_names :keys
        attr_reader :name
      
        def initialize name, store=nil
          @name, @data_store = name.to_s, store
        end
      end
    
      class Column
        attr_reader :name
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
        def allows_null?
          @allows_null
        end
      end
    
    end
  end
end
