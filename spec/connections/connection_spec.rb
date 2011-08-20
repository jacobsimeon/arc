require 'spec_helper'

module Arc
  module Connections
    describe AbstractConnection do
      
      it 'specifies methods that should be overwritten by specific adapters' do
        c = AbstractConnection.new
        c.should respond_to(:execute)
        lambda { c.execute "INSERT INTO superheros VALUES(superman)"}.should raise_error(NotImplementedError)
      end
            
    end
  end
end
