require 'spec_helper'

describe Array do
  describe '#symbolize_keys!' do
    it 'runs symbolize_keys! on hash elements' do
      wrapped_hash = [{'superman' => 'is awesome'}].symbolize_keys!
      wrapped_hash[0][:superman].should == 'is awesome'
    end    
  end  
end