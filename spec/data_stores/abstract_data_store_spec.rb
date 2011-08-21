require 'spec_helper'

module Arc
  module DataStores
    describe AbstractDataStore do
      
      describe '#new' do
        it 'creates an instance which has access to a connection pool' do
          store = AbstractDataStore.new ArcTest.config[:empty]
          pool = store.send :pool
          pool.should be_a(ConnectionPool)
        end
        
        it 'does not define connection creation' do
          store = AbstractDataStore.new ArcTest.config[:empty]
          pool = store.send :pool
          ->{ pool.connection}.should raise_error(NotImplementedError)
        end        
      end
            
    end
  end
end
    
    