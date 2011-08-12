require 'spec_helper'

class FakeReactor
  include Arc::Reactor
end




module Arc
  describe Reactor do
    describe '#connect' do
      it 'creates a new connection pool and registers it with the connection handler' do
        FakeReactor.connect(:adapter => :sqlite3, :database => 'fake_database.sqlite3')
        ConnectionHandler.connections[FakeReactor].should be_a(ConnectionPool)      
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