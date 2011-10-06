require 'spec_helper'

module Arc
  module Schemas
    describe "All the Schemas!" do

      describe '#load' do
        it 'creates a schema by executing DDL sql' do
          ArcTest.with_store do |store|
            store.schema.table_names.should include(:superheros)            
          end          
        end
      end
      
      
    end
  end
end