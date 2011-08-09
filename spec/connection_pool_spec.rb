require 'spec_helper.rb'

describe Arc::ConnectionPool do
  
  def config
    @config ||= {
      :adapter => 'sqlite3',
      :database => 'fixture.sqlite3',
      :timeout => 0.5
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
        connection.should be_an(Arc::ConnectionPool::Connection)
        Thread.current[:connection] = connection
      end
    end
    threads.each {|t| t.join }    
  end
    
  describe '#connection' do
    it 'creates new connection objects for each running thread' do
      pool = Arc::ConnectionPool.new(config)
      threads = thread_connections pool, 4
      checked_out(pool).keys.size.should === 4
      while threads.size > 0 do
        t = threads.pop
        t[:connection].should === checked_out(pool)[t.object_id]
        t.kill
      end
    end
    
    it 'clears connections for expired threads' do
      pool = Arc::ConnectionPool.new(config)
      threads = thread_connections(pool, 5)
      checked_out(pool).keys.size.should == 5
      c = pool.connection
      checked_out(pool).keys.size.should === 1
      checked_out(pool)[Thread.current.object_id].should === c      
    end
    
    it 'throws exception when no connections are available after timeout' do
      mini_pool = Arc::ConnectionPool.new(
        :adapter => :sqlite3,
        :database => 'fixture.sqlite3',
        :size => 1,
        :timeout => 0.5
      )
      sleeper = Thread.start do
        Thread.current[:connection] = mini_pool.connection
        sleep 10000
      end
      Thread.new do
        lambda { mini_pool.connection }.should raise_error Arc::ConnectionPool::ResourcePoolTimeoutError
        sleeper.kill      
      end.join
    end
    
  end
  
end
