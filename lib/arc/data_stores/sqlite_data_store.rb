require 'sqlite3'
module Arc
  module DataStores
    class SqliteDataStore < AbstractDataStore
      
      private
      def create_connection
        SQLite3::Database.new @config[:database], :results_as_hash => true
      end
      
      def execute query
        with_connection do |connection|
          result = connection.execute(query)
        end
      end
      
    end
  end
end