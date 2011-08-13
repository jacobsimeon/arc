require 'arc/connections/connection.rb'
require 'arc/connections/sqlite3_connection.rb'

module Arc
  module Connections
    class AdapterNotFoundError < StandardError; end
    class AdapterNotSpecifiedError < StandardError; end
    
    CONNECTIONS ||= {
      :sqlite3 => Sqlite3Connection
    }

    def self.connection_for config
      unless config.keys.include? :adapter
        raise AdapterNotSpecifiedError, "Arc::Connections - please specify an adapter"
      end
      adapter = config[:adapter].to_sym
      unless CONNECTIONS.keys.include? adapter
        raise AdapterNotFoundError, "Arc::Connections cannot find adapter #{adapter}"
      end
      
      CONNECTIONS[adapter].new config
    end
    
  end
end