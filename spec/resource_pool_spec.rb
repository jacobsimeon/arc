require 'spec_helper.rb'
class StringPool < ResourcePool
  def create_resource
    "resource ##{@resources.size}"
  end
end

module Arc
  describe ResourcePool do
    
    def checked_out(pool)
      pool.instance_variable_get(:@checked_out)
    end
    
    def thread_resources(pool, count=4)
      threads = []
      count.times do |i|
        threads << Thread.start do
          resource = pool.send :resource
          resource.should be_a(String)
          Thread.current[:resource] = resource
        end
      end
      threads.each {|t| t.join }
    end
        
    describe '#resource' do
    
      it 'creates a new object for each running thread' do
        pool = StringPool.new :pool => 5, :timeout => 5
        threads = thread_resources pool, 4
        checked_out(pool).keys.size.should === 4
        while t = threads.pop do
          resources = checked_out(pool)
          #verify connection is associated to the appropriate thread
          t[:resource].should === resources.delete(t.object_id)
          #make sure the array isn't just holding duplicate objects
          resources.values.should_not include(t[:resource])
        end
      end
    
      it 'clears resources from expired threads' do
        pool = StringPool.new :pool => 5, :timeout => 0.1
        threads = thread_resources(pool, 5)
        checked_out(pool).keys.size.should == 5
        c = pool.with_resource do |resource|
          checked_out(pool).keys.size.should === 1
          checked_out(pool)[Thread.current.object_id].should === resource          
        end
      end
    
      it 'raises error when no resources are available after timeout' do
        pool = StringPool.new :pool => 1, :timeout => 0.1
        pool.with_resource do |resource|
          checked_out(pool).keys.size.should === 1
          Thread.start do
            ->{ pool.with_resource }.should raise_error ResourcePool::ResourcePoolTimeoutError
          end.join
        end
      end
    
    end
        
    describe '#checkin' do
      it 'makes a connection available for use by another thread' do
        pool = StringPool.new :pool => 1, :timeout => 0.1
        resource = pool.with_resource do |resource|
          checked_out(pool).keys.size.should === 1
          Thread.start do
            ->{ pool.with_resource }.should raise_error ResourcePool::ResourcePoolTimeoutError
          end.join
          resource
        end
        final = Thread.start do
          Thread.current[:resource] = pool.with_resource { |resource| resource }
        end.join
        final[:resource].should === resource
      end
      
      it 'uses the current thread id when no argument is passed' do
        pool = StringPool.new :pool => 5, :timeout => 5
        c = pool.with_resource do |resource|
          resource
        end
        pool.with_resource do |resource|
          resource.should be(c)
        end
      end
      
    end
    
    describe '#with_resource' do
      it 'uses a resource then checks it back in' do
        pool = StringPool.new :pool => 5, :timeout => 5
        pool.with_resource do |resource|
          resource.should be_a(String)
          checked_out(pool).keys.size.should == 1
        end
        checked_out(pool).keys.size.should == 0 
      end
      it 'returns the expected value' do
        pool = StringPool.new :pool => 5, :timeout => 5
        string = pool.with_resource do |resource|
          resource.should be_a(String)
          checked_out(pool).keys.size.should == 1
          "this is the value"
        end
        string.should == "this is the value"        
      end
    end
  
  end
end