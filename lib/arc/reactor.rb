module Arc
  module Reactor  
    
    def self.included(klass)
      klass.extend(ClassMethods)
    end
    
    def data_store
      self.class.data_store
    end
    
    module ClassMethods
      def connect(config, klass=self)
        @@data_store = Arc::DataStore.new(config, klass)
      end      
      def data_store
        @@data_store
      end
    end
    
  end    
end

#Example Use:
# class MyReactorBase
#   include Arc::Reactor
#   connect("hello world")
# end

