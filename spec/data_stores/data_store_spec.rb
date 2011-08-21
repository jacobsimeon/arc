require 'spec_helper'

module Arc
  module DataStores
    describe 'The data store' do
      
      before :all do
        ArcTest.load_schema
      end
      after :all do
        ArcTest.drop_schema
      end
      
      describe '#execute' do
        it 'executes the query' do
          result = ArcTest.store.send :execute, 'SELECT * from sqlite_master'
          result[0].should be_a(Hash)
          result[0]['type'].should == 'table'
          result[0]['name'].should == 'superheros'          
        end
      end
                  
    end
  end
end
    