require 'spec_helper'

module Arc
  module DataStores
    describe 'The data store' do      
      describe '#execute' do
        
        before :all do
          ArcTest.load_schema
        end
        after :all do
          ArcTest.drop_schema
        end
        
        it 'executes the query' do
          heros = ['superman', 'batman', 'spiderman']
          result = ArcTest.store.send :execute, 'SELECT * FROM superheros'
          result.size.should == 3
          result.each do |h| 
            h.should be_a(Hash)
            h.symbolize_keys!
            heros.should include(h[:name])
          end
        end
        
      end
                  
    end
  end
end
    