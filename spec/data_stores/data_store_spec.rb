require 'spec_helper'

module Arc
  module DataStores
    describe 'The data store' do
      
      def store
        @store ||= DataStores.create_store ArcTest.config[ENV['ARC_ENV'].to_sym]
      end
      
      describe '#new' do
        it 'creates a SqliteDataStore with a connection to sqlite database' do
          store.send :with_connection do |connection|
            connection.should_not be_nil
          end
        end
      end
      
      describe '#execute' do
        it 'executes the query' do
          store.send :execute, 'CREATE TABLE superheros( id INT NOT NULL )'
          result = store.send :execute, 'SELECT * from sqlite_master'
          result[0].should be_a(Hash)
          result[0]['type'].should == 'table'
          result[0]['name'].should == 'superheros'          
        end
      end
                  
    end
  end
end
    