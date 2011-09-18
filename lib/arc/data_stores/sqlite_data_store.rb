require 'sqlite3'

module Arc
  module DataStores
    class SqliteDataStore < AbstractDataStore
      
      def read query
        case query
        when String
          execute(query).symbolize_keys!
        when Arel::SelectManager
          execute(query.to_sql).symbolize_keys!
        end
      end
      
      def create sql
        table = sql.match(/\AINSERT into ([^ (]*)/i)[1]
        execute(sql)
        read("select * from #{table} where id = last_insert_rowid();")[0]
      end
      
      def update sql
        execute sql
      end
      
      def destroy sql
        execute sql
      end
      
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
