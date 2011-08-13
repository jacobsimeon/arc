require 'spec_helper'
require 'sqlite3'

module Arc
  module Connections
    describe Sqlite3Connection do
      def config
        @config ||= {
          :database => ':memory:'
        }
      end
      
      
      
      describe '#new' do
        it 'creates a connection to sqlite3 database' do
          connection = Sqlite3Connection.new(config)
          raw_connection = connection.instance_variable_get :@raw_connection
          raw_connection.should be_a(SQLite3::Database)
          
          
        end        
      end   
    end
  end
end