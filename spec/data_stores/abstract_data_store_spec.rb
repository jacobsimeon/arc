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
            
    end
  end
end
    
    