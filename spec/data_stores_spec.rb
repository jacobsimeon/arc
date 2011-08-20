require 'spec_helper'

module Arc
  module DataStores
    class FakeDataStore < AbstractDataStore; end
    STORES[:fake] = FakeDataStore
  end
end

module Arc
  describe DataStores do
    describe '#[]' do
      
      it 'retrieves data store for the specified adapter' do
        DataStores[:fake].should be(DataStores::FakeDataStore)        
      end
      
      it 'tries to require data store adapter if not found' do
        ->{ DataStores::SupermanDataStore }.should raise_error(NameError)
        DataStores[:superman].should be(DataStores::SupermanDataStore)        
      end
      
      it 'raises AdapterNotFoundError when the specified adapter does not exist' do
        ->{ DataStores[:batman] }.should raise_error(DataStores::AdapterNotFoundError)
      end
    
    end
    
    describe '#create_store' do
      it 'raises AdapterNotSpecified' do
        ->{ DataStores.create_store({}) }.should raise_error(DataStores::AdapterNotSpecifiedError)
      end

      it 'creates and returns a new instance of the specified data store' do
        store = DataStores.create_store ArcTest.config[:empty]
        store.should be_a(DataStores::DefaultDataStore)  
      end
            
    end
  end  
end