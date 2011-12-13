require 'spec_helper'

module Arc
  module DataStores
    describe 'The data store crud operations' do      
      
      describe '#schema' do
        it 'creates a schema object for the correct adapter' do
          ArcTest.with_store do |store|
            store.schema.should be_a(Arc::Schemas[ArcTest.adapter])
          end
        end
        it 'passes a reference to -self- to the schema' do
          ArcTest.with_store do |store|
            store.schema.instance_variable_get(:@data_store).should be(store)
          end
        end
      end
      
      describe '#create' do
        it 'creates a new record' do
          ArcTest.with_store do |store|
            query = "SELECT * FROM superheros WHERE name = 'green hornet'"
            result = store.read query
            result.size.should == 0
          
            store.create "INSERT INTO superheros (name) VALUES('green hornet');"
            store.read(query).size.should == 1
          
            #cleanup
            store.destroy "DELETE FROM superheros where name = 'green hornet'"
          end
        end
        
        it 'returns the record with a populated primary key' do
          ArcTest.with_store do |store|
            result = store.create "INSERT INTO superheros (name) VALUES('green lantern')"
            result[:id].should_not be_nil
            result[:name].should == 'green lantern'
            #cleanup
            store.destroy "DELETE FROM superheros where name = 'green lantern'"
          end
        end
      end
      
      describe '#read' do
        it 'reads existing data' do
          heros = ['superman', 'batman', 'spiderman']
          query = "SELECT * FROM superheros"
          
          ArcTest.with_store do |store|
            result = store.read query
            result.size.should == 3
            result.each do |h| 
              h.should be_a(Hash)
              heros.should include(h[:name])
            end
          end
        end
      end
      
      describe '#update' do
        it 'updates a record and returns the updated record' do
          ArcTest.with_store do |store|
            query = "UPDATE superheros SET name = 'wussy' WHERE name = 'batman'"
            result = store.update query
            batman = store.read "SELECT * from superheros WHERE name = 'batman'"
            batman.size.should == 0
            batman.should be_a(Enumerable)
            batman = store.read "SELECT * from superheros WHERE name = 'wussy'"
            batman.first[:name].should == 'wussy'
          end
        end
      end
      
      describe '#destroy' do
        it 'deletes a record' do 
          ArcTest.with_store do |store|
            query = "SELECT * FROM superheros WHERE name = 'batman'"
            batman = store.read query
            batman.first[:name].should == 'batman'
            store.destroy "DELETE FROM superheros WHERE name = 'batman'"
            batman = store.read query
            batman.size.should == 0
            batman.should be_a(Enumerable)
          end
        end        
      end

    end
  end
end
