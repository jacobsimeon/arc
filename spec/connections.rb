require 'spec_helper'

module Arc
  module Connections
    describe '#connection_for' do

      it 'creates a connection for the specified adapter' do
        sqlite3_connection = Connections.connection_for(:adapter => :sqlite3)
        sqlite3_connection.should be_a(Connection)
        sqlite3_connection.should be_a(Sqlite3Connection)
      end
      
      it 'raises AdapterNotFoundError when the specified adapter does not exist' do
        lambda {Connections.connection_for :adapter => :superman}.should raise_error(AdapterNotFoundError)
      end
      
      it 'raise AdapterNotSpecifiedError when configuration does not have an :adapter key' do
        lambda {Connections.connection_for :superman => 1 }.should raise_error(AdapterNotSpecifiedError)
      end

    end
  end  
end