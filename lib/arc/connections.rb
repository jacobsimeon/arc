require 'arc/connection_adapters/connection.rb'
require 'arc/connection_adapters/sqlite3_connection.rb'

module Arc
  module Connections
    CONNECTIONS ||= {
       :sqlite3 => Sqlite3Connection
     }

    def self.connection_for adapter
      CONNECTIONS[adapter]
    end
  end
end