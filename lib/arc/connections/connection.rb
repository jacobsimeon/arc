module Arc
  module Connections
    class Connection
      
      def execute sql
        not_implemented :execute
      end
      
      private
      def not_implemented method
        raise NotImplementedError, <<-ERROR
          "Arc::Connections::Connection does not implement ##{method}.  This method should be overwritten by derived classes"
        ERROR
      end 

    end
  end
end