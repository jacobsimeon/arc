require 'spec_helper'

module Arc
  describe Schemas do
    it 'extends Q::Dispatcher' do
      Schemas.should be_a(Q::Dispatcher)
    end
    it "specifies 'DataStore' as the constant_suffix" do
      Schemas.instance_variable_get(:@constant_suffix).should == "Schema"
    end
    it "specifies 'arc/schemas/%s_schema' as the require_pattern" do
      Schemas.instance_variable_get(:@require_pattern).should == "arc/schemas/%s_schema"
    end
  end  
end