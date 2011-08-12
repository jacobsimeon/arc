require 'spec_helper.rb'

module Arc
  describe ConnectionPool do
  
    def config
      @config ||= {
        :adapter => 'sqlite3',
        :database => 'fixture.sqlite3',
        :timeout => 0.1
      }
    end
  
    def checked_out(pool)
      pool.instance_variable_get(:@checked_out)
    end
  
    def thread_connections(pool, count=4)
      threads = []
      count.times do |i|
        threads << Thread.start do
          connection = pool.connection
          connection.should be_an(Connection)
          Thread.current[:connection] = connection
        end
      end
      threads.each {|t| t.join }    
    end
    
    describe '#connection' do
    
      it 'creates a new connection object for each running thread' do
        pool = ConnectionPool.new(config)
        threads = thread_connections pool, 4
        checked_out(pool).keys.size.should === 4
        while t = threads.pop do
          connections = checked_out(pool)
          #verify connection is associated to the appropriate thread
          t[:connection].should === connections.delete(t.object_id)
          #make sure the array isn't just holding duplicate objects
          connections.values.should_not include(t[:connection])
        end
      end
    
      it 'clears connections from expired threads' do
        pool = ConnectionPool.new(config)
        threads = thread_connections(pool, 5)
        checked_out(pool).keys.size.should == 5
        c = pool.connection
        checked_out(pool).keys.size.should === 1
        checked_out(pool)[Thread.current.object_id].should === c      
      end
    
      it 'raises error when no connections are available after timeout' do
        mini_pool = ConnectionPool.new(
          :adapter => :sqlite3,
          :database => 'fixture.sqlite3',
          :size => 1,
          :timeout => 0.1
        )
        connection = mini_pool.connection
        checked_out(mini_pool).keys.size.should === 1
        Thread.start do
          lambda { mini_pool.connection }.should raise_error ConnectionPool::ResourcePoolTimeoutError
        end.join
      end
    
    end
  
    describe '#checkin' do
      it 'makes a connection available for use by another thread' do
        pool = ConnectionPool.new(
          :adapter => :sqlite3,
          :database => 'fixture.sqlite3',
          :size => 1,
          :timeout => 0.1
        )
        connection = pool.connection
        checked_out(pool).keys.size.should === 1
        Thread.start do
          lambda{ pool.connection }.should raise_error ConnectionPool::ResourcePoolTimeoutError
        end.join
        pool.checkin Thread.current.object_id
        final = Thread.start do
          Thread.current[:connection] = pool.connection
        end.join
        final[:connection].should === connection      
      end
      it 'uses the current thread id when no argument is passed' do
        pool = ConnectionPool.new(
          :adapter => :sqlite3,
          :database => 'fixture.sqlite3',
          :size => 1,
          :timeout => 0.1
        )
        pool.connection
        pool.checkin      
      end

    end
  
  end
end