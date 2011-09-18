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
      
      describe '#schema' do
        it 'creates a schema object for the correct adapter' do
          ArcTest.store.schema.should be_a(Arc::Schemas[ArcTest.adapter])
        end
        it 'passes a reference to -self- to the schema' do
          ArcTest.store.schema.instance_variable_get(:@data_store).should be(ArcTest.store)
        end
      end
      
      describe '#create' do
        it 'creates a new record' do
          query = "SELECT * FROM superheros WHERE name = 'green hornet'"
          result = ArcTest.store.read query
          result.size.should == 0
          
          ArcTest.store.create "INSERT INTO superheros (name) VALUES('green hornet');"
          ArcTest.store.read(query).size.should == 1
          
          #cleanup
          ArcTest.store.destroy "DELETE FROM superheros where name = 'green hornet'"
                    
        end
        it 'returns the record with a populated primary key' do
          result = ArcTest.store.create "INSERT INTO superheros (name) VALUES('green lantern')"
          result[:id].should_not be_nil
          result[:name].should == 'green lantern'
          #cleanup
          ArcTest.store.destroy "DELETE FROM superheros where name = 'green lantern'"
        end
      end
      
      describe '#read' do
        it 'reads existing data' do
          heros = ['superman', 'batman', 'spiderman']
          query = "SELECT * FROM superheros"
          
          result = ArcTest.store.read query
          result.size.should == 3
          result.each do |h| 
            h.should be_a(Hash)
            heros.should include(h[:name])
          end
        end
      end
      
      describe '#update' do
        it 'updates a record and returns the updated record' do
          query = "UPDATE superheros SET name = 'wussy' WHERE name = 'batman'"
          result = ArcTest.store.update query
          batman = ArcTest.store.read "SELECT * from superheros WHERE name = 'batman'"
          batman.should == []
          batman = ArcTest.store.read "SELECT * from superheros WHERE name = 'wussy'"
          batman[0][:name].should == 'wussy'
        end
      end
      
      describe '#destroy' do
        it 'deletes a record' do 
          query = "SELECT * FROM superheros WHERE name = 'wussy'"
          batman = ArcTest.store.read query
          batman[0][:name].should == 'wussy'
          ArcTest.store.destroy "DELETE FROM superheros WHERE name = 'wussy'"
          batman = ArcTest.store.read query
          batman.should == []
        end        
      end

    end
  end
end
    