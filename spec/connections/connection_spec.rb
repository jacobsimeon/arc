require 'spec_helper'

module Arc
  module Connections
    describe Connection do
      
      it 'specifies methods that should be overwritten by specific adapters' do
        c = Connection.new
        c.should respond_to(:execute)
        c.should respond_to(:active?)
        
        lambda { c.execute "INSERT INTO superheros VALUES(superman)"}.should raise_error(NotImplementedError)
        lambda { c.active? }.should raise_error(NotImplementedError)
      end
            
    end
  end
end
