require 'q/collector'
module Arc
  module Schemas

    class Schema
      include Collector
      alias :table_names :keys
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
