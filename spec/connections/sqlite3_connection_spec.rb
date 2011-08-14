require 'spec_helper'

module Arc
  module Connections
    describe Sqlite3Connection do
      before :all do
        setup
      end
      def connection
        @connection ||= Sqlite3Connection.new :database => ':memory:'
      end
      def setup
        connection.execute <<-SQL
          CREATE TABLE superheros (
            name VARCHAR(256) NOT NULL
          )
        SQL
      end      
          
      describe '#new' do
        it 'creates a connection to sqlite3 database' do
          raw_connection = connection.instance_variable_get :@raw_connection
          raw_connection.should be_a(SQLite3::Database)        
        end
      end
      
      describe '#execute' do
        it 'executes the provided sql statement and returns the result' do
          insert_result = connection.execute <<-SQL
            INSERT INTO superheros
            VALUES ('superman')
          SQL
          insert_result.should be_a(Array)
          select_result = connection.execute <<-SQL
            SELECT * FROM superheros
          SQL
          select_result.should be_a(Array)
          select_result[0].should be_a(Hash)
          select_result[0]['name'].should == "superman"
        end      
      end
            
    end
  end
end