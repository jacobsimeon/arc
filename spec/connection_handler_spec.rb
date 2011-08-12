require 'spec_helper.rb'

module Arc
  describe ConnectionHandler do

    def seed_connection(klass)
      ConnectionHandler.add_connection({
        :adapter => :sqlite3,
        :database => 'my_test_database.sqlite3'          
      }, klass)      
    end


    describe 'add_connection' do
      it 'creates a connection pool' do
        pool = ConnectionHandler.add_connection({
          :adapter => :sqlite3,
          :database => 'my_test_database.sqlite3'          
        })
        pool.should be_a(ConnectionPool)
      end
      it 'does not create a connection for a class with an already existing connection' do
        pool = ConnectionHandler.add_connection({
          :adapter => :sqlite3,
          :database => 'my_test_database.sqlite3'          
        })
        pool.object_id.should === ConnectionHandler.add_connection({
          :adapter => :sqlite3,
          :database => 'my_test_database.sqlite3'          
        }).object_id    
      end
    end 

    describe 'with_connection' do
      it 'yields a connection object to the passed block' do
        seed_connection Object
        ConnectionHandler.with_connection do |connection|
          connection.should be_a(ConnectionPool::Connection)
        end
      end
      it 'checks in the connection after use' do
        seed_connection Object
        connection_id = nil
        ConnectionHandler.with_connection do |connection|
          connection_id = connection.object_id
        end
        ConnectionHandler.connections[Object].instance_variable_get(:@checked_out).keys.size.should === 0        
      end
      it 'yields the connection object associated to the passed class' do
        seed_connection String
        seed_connection Array
        ConnectionHandler.connections[String].should be_a(ConnectionPool)
        ConnectionHandler.connections[Array].should be_a(ConnectionPool)
        ConnectionHandler.connections[String].object_id.should_not be(ConnectionHandler.connections[Array].object_id)  
      end      
    end      

  end  
end