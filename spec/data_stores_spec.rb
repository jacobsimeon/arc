require 'spec_helper'

module Arc
  module DataStores
    class FakeDataStore < DataStore; end
    STORES[:fake] = FakeDataStore
  end
end


module Arc
  describe DataStores do
    describe '#[]' do
      it 'retrieves data store which is associated to the specified adapter' do
        DataStores[:fake].should be(DataStores::FakeDataStore)        
      end
      it 'returns default data store when store cannot be found for specified adapter' do
        DataStores[:superman].should be(DataStores::DataStore)
      end
    end
  end
end