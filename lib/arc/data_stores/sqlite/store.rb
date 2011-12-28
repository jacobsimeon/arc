require 'sqlite3'
require 'arc/data_stores/sqlite/object_definitions'

module Arc
  module DataStores
    class SqliteDataStore < AbstractDataStore

      def execute query
        with_store do |connection|
          result = connection.execute(query).symbolize_keys!
        end
      end
      
      def schema
        @schema ||= ObjectDefinitions::SqliteSchema.new self
      end
      
      private
      def create_connection
        SQLite3::Database.new @config[:database], :results_as_hash => true
      end
            
    end
  end
end
