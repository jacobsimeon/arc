require 'spec_helper'

module Arc
  module DataStores
    describe AbstractDataStore do
      describe '#new' do
        it 'creates an instance which has access to a connection pool' do
          store = AbstractDataStore.new ArcTest.config[:empty]
          pool = store.instance_variable_get(:@pool)
          pool.should be_a(ConnectionPool)
          pool.connection.should be_a(Connections::AbstractConnection)
          pool.checkin
        end
      end
      
      
      
    end
  end
end
    
    