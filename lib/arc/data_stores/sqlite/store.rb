require 'sqlite3'
require 'arc/data_stores/sqlite/object_definitions'

module Arc
  module DataStores
    class SqliteDataStore < AbstractDataStore
      
      def read query
        execute(query).symbolize_keys!
      end
      
      def create sql
        table = sql.match(/\AINSERT into ([^ (]*)/i)[1]
        execute sql
        read("select * from #{table} where id = last_insert_rowid();")[0]
      end
      
      def update sql
        execute sql
      end
      
      def destroy sql
        execute sql
      end

      def execute query
        with_store do |connection|
          result = connection.execute(query)
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
