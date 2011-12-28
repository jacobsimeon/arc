require 'pg'
require 'arc/data_stores/postgres/object_definitions'

module Arc
  module DataStores
    class PostgresDataStore < AbstractDataStore
      
      def execute query
        with_store { |connection| connection.exec query }.to_a.symbolize_keys!
      end
      
      def schema
        @schema ||= ObjectDefinitions::PostgresSchema.new self
      end
      
      def quote_binary data
        with_store do |store|
          "'#{store.escape_bytea data}'"
        end
      end
      
      def cast_binary data
        with_store do |store|
          store.unescape_bytea data
        end
      end
      
      def last_insert_rowid table, field
        id = execute("SELECT currval('#{table}_#{field}_seq');")[0][:currval]
      end
      
      private
      def create_connection
        PGconn.connect({
          :dbname => @config[:database],
          :user => @config[:user],
          :password => @config[:password],
          :host => @config[:host],
          :port => @config[:port]
        })
      end
    end
  end
end
