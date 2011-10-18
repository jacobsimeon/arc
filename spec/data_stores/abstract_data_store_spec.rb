require 'spec_helper'

module Arc
  module DataStores
    describe AbstractDataStore do
      
      # it 'includes quoting module' do
      #   ArcTest.store.class.included_modules.should include(Arc::Quoting)
      # end
      
      describe '#new' do
        it 'does not define connection creation' do
          store = AbstractDataStore.new ArcTest.config[:empty]
          ->{ store.send :with_connection }.should raise_error(NotImplementedError)
        end
      end
      describe 'abstract methods throw NotImplementedError' do
        before :each do
          @store = AbstractDataStore.new ArcTest.config[:empty]
          @query = "omg"
        end
        it '#create raises not implemented error' do
          ->{ @store.create @query }.should raise_error(NotImplementedError)
        end
        it '#read raises not implemented error' do
          ->{ @store.read @query }.should raise_error(NotImplementedError)          
        end
        it '#update raises not implemented error' do
          ->{ @store.update @query }.should raise_error(NotImplementedError)          
        end
        it '#destroy raises not implemented error' do
          ->{ @store.destroy @query }.should raise_error(NotImplementedError)          
        end
        it '#execute raises not implemented error' do
          ->{ @store.execute @rquery }.should raise_error(NotImplementedError)          
        end
      end
    end
  end
end
    
    