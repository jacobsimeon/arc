module Arc
  module Schemas
    class SchemaBase
      def initialize data_store
        @tables = {}
        @data_store = data_store
      end
      def [] name
        @tables[name] ||= fetch_table(name)
      end
      def table_names
        @table_names ||= fetch_table_names
      end
      def fetch_table_names
        raise NotImplementedError
      end
      def fetch_table name
        raise NotImplementedError
      end
    end
  end
end