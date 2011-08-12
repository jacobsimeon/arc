require 'spec_helper'

class FakeReactor
  include Arc::Reactor
end

class SuperFakeReactor < FakeReactor; end



module Arc
  describe Reactor do
    describe '#connect' do
      it 'creates a new connection pool and registers it with the connection handler' do
        FakeReactor.connect(:adapter => :sqlite3, :database => 'fake_database.sqlite3')
        ConnectionHandler.connections[FakeReactor].should be_a(ConnectionPool)      
      end
      it 'redefines the data_source for derived classes with a different configuration' do
        FakeReactor.connect({})
        ConnectionHandler.connections.size.should be(1)
        ConnectionHandler.connections[FakeReactor].should be_a(ConnectionPool)
        SuperFakeReactor.connect({})
        ConnectionHandler.connections.size.should be(2)
        ConnectionHandler.connections[SuperFakeReactor].should be_a(ConnectionPool)
        ConnectionHandler.connections[SuperFakeReactor].object_id.should_not be(ConnectionHandler.connections[FakeReactor].object_id)
        SuperFakeReactor.data_store.should_not be(FakeReactor.data_store)
        
      end     
    end
    describe '#data_source' do
      it 'yields an Arc::DataSource object associated with the proper class' do
        FakeReactor.connect({})
        FakeReactor.data_store.should be_a(DataStore)
        FakeReactor.data_store.klass.should be(FakeReactor)
      end      
    end    
  end  
end