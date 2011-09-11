require 'monitor'

class ResourcePool
  class ResourcePoolTimeoutError < StandardError; end
  
  def initialize config
    extend MonitorMixin
    @config = config
  end
  
  def with_resource
    result = yield resource
    checkin
    result
  end
  
  def create_resource
    raise NotImplementedError
  end

  def config
    @config ||= {}
  end
  
  private
  def queue
    @queue ||= new_cond
  end
  def resources
    @resources ||= []
  end
  def checked_out
    @checked_out ||= {}
  end
  def timeout
    config[:timeout] || 5
  end
  def size
    config[:pool] || 5
  end

  def resource
    checked_out[Thread.current.object_id] ||= checkout
  end    
  
  def checkin(thread_id=Thread.current.object_id)
    synchronize do
      checked_out.delete(thread_id)
      queue.signal 
    end
  end
  
  def find_resource
    if resource_available?
      find_existing_resource
    elsif can_create_new?
      add_new_resource
    end
  end
  
  def clear_stale_resources!
    #find all currenly live threads and check in their corresponding connections
    alive = Thread.list.find_all { |t| t.alive? }.map { |thread| thread.object_id }
    dead = checked_out.keys - alive
    dead.each { |t| checkin t }
  end
  
  def resource_available?
    checked_out.keys.size < resources.size
  end
  
  def can_create_new?
    resources.size < size
  end
  
  def checkout
    #Checkout an available connection or create a new one
    synchronize do
      resource = find_resource
      return resource unless resource.nil?
      queue.wait timeout
      clear_stale_resources!
      raise ResourcePoolTimeoutError unless can_create_new? or resource_available?
    end
    checkout
  end      

  def find_existing_resource
    (resources - checked_out.values).first
  end
  
  def add_new_resource
    resources << r = create_resource; r
  end
  
end
  