require 'sqlite3'
module Arc
  module Connections
    class Sqlite3Connection < AbstractConnection
      def initialize config
        @raw_connection = SQLite3::Database.new config[:database], :results_as_hash => true
      end
      def execute sql
        @raw_connection.execute sql
      end
    end
  end
end