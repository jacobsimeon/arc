require 'spec_helper.rb'

describe Arc::ConnectionPool do
  
  before :each do
    @connection_pool ||= Arc::ConnectionPool.new(
      :adapter => 'sqlite3',
      :database => 'fixture.sqlite3',
    )
  end
  def pool
    @connection_pool
  end
  
  describe '#new' do
    it 'should create a new instance' do
      Arc::ConnectionPool.new(:adapter => :sqlite3, :database => 'fixture.sqlite3').should be_a Arc::ConnectionPool      
    end
  end
  
  describe '#connection' do
    it 'creates and yields new connection objects for each thread' do
       connection = pool.connection
       connection.should_not be_nil
       threads = []
       
       #get a connection from 4 threads
       4.times do |i|
         threads << Thread.new(i) do |pool_count|
           connection = pool.connection
           connection.should_not be_nil
         end       
       end
       threads.each {|t| t.join}
       
       Thread.new do
         threads.each do |t|
           thread_ids = pool.instance_variable_get(:@checked_out).keys
           thread_ids.should include(t.object_id)
         end
        
        #get a new connection to purge connections associated to dead threads
        pool.connection
        threads.each do |t|
          thread_ids = pool.instance_variable_get(:@checked_out).keys
          thread_ids.should_not include(t.object_id)
        end
       end.join()
    end
    
    it 'throws exception if timeout limit is reached' do
      threads = []
      #get a connection from 4 threads
      lambda do
        7.times do |i|
          threads << Thread.new(i) do |pool_count|
            connection = pool.connection
            connection.should_not be_nil
          end
        end
        threads.each {|t| t.join}
      end.should raise_error Arc::ConnectionPool::ResourcePoolTimeoutError
      
    end
    
  end
  
end
