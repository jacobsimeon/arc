require 'arc/connections/connection.rb'
require 'arc/connections/sqlite3_connection.rb'

module Arc
  module Connections
    class AdapterNotFoundError < StandardError; end
    
    CONNECTIONS ||= {
      :sqlite3 => Sqlite3Connection
    }

    def self.connection_for config
      unless CONNECTIONS.keys.include? config[:adapter].to_sym
        raise AdapterNotFoundError, "Arc::Connections cannot find adapter #{config[:adapter]}"
      end
      CONNECTIONS[config[:adapter].to_sym].new config
    end
    
  end
end