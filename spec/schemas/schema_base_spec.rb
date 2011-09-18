require 'spec_helper'

module Arc
  module Schemas
    describe SchemaBase do

      class FakeSchema < SchemaBase
        def fetch_table_names
          [:superheros, :villains]
        end
        def fetch_table name
          @table_cache ||= {
            superheros: {
              columns: []
            },
            villains: {
              columns: [] 
            }
          }
          @table_cache[name]
        end      
      end

      before :each do
        @schema = SchemaBase.new ArcTest.store
        @fake_schema = FakeSchema.new ArcTest.store
      end
      
      describe '#new' do
        it 'sets the datastore' do
          @schema.instance_variable_get(:@data_store).should == ArcTest.store
        end
      end
      
      it 'responds to #[]' do
        @schema.should respond_to(:[])
        @fake_schema[:superheros][:columns].should == []
      end
      
      it 'responds to #table_names' do
        @fake_schema.table_names.should == [:superheros, :villains]
      end
      
      it 'responds to #fetch_table_names' do
        @schema.should respond_to(:fetch_table_names)
        ->{ @schema.fetch_table_names }.should raise_error(NotImplementedError)
      end
      
      it 'responds to #fetch_table' do
        @schema.should respond_to(:fetch_table)
        ->{ @schema.fetch_table :not_a_table }.should raise_error(NotImplementedError)
      end
    end
    
  end
end