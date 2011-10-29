require 'spec_helper'

module Arc
  describe DataStores do
    it 'extends Q::Dispatcher' do
      DataStores.should be_a(Q::Dispatcher)
    end
    it "specifies 'DataStore' as the constant_suffix" do
      DataStores.instance_variable_get(:@constant_suffix).should == "DataStore"
    end
    it "specifies 'arc/data_stores/%s_data_store' as the require_pattern" do
      DataStores.instance_variable_get(:@require_pattern).should == "arc/data_stores/%s_data_store"
    end
  end  
end