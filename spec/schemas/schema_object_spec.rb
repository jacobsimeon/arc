require 'spec_helper'

module Arc
  module Schemas
    describe SchemaObject do
      class FakeSchemaObject < SchemaObject
        def fetch_item_names
          [:superheros, :villains]
        end
        def fetch_item name
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
        @schema = SchemaObject.new ArcTest.store, "superheros_schema"
        @fake_schema = FakeSchemaObject.new ArcTest.store
      end
      
      describe '#new' do
        it 'sets the datastore' do
          @schema.instance_variable_get(:@data_store).should == ArcTest.store
        end
        it 'sets the object name' do
          @schema.name.should == "superheros_schema"
        end
      end
      
      it 'responds to #[]' do
        @fake_schema[:superheros][:columns].should == []
      end
      
      it 'responds to #item_names' do
        @fake_schema.item_names.should == [:superheros, :villains]
      end
      
      it 'responds to #fetch_item_names' do
        @schema.should respond_to(:fetch_item_names)
        ->{ @schema.fetch_item_names }.should raise_error(NotImplementedError)
      end
      
      it 'responds to #fetch_item' do
        @schema.should respond_to(:fetch_item)
        ->{ @schema.fetch_item :not_a_table }.should raise_error(NotImplementedError)
      end

    end  
  end
end