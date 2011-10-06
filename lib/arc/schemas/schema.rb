require 'q/collector'
module Arc
  module Schemas

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
    
    class Schema::Table
      include Collector
      alias :column_names :keys
    end
    
    class Schema::Table::Column
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
