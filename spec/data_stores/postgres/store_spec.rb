require 'spec_helper'
require 'arc/data_stores/postgres/store'

describe Arc::DataStores::PostgresDataStore do
  describe "#schema" do
    it 'is an instance of Arc::DataStores::PostgresSchema' do
      store = Arc::DataStores::PostgresDataStore.new ArcTest.config[:Postgres]
      store.schema.should be_a(Arc::DataStores::ObjectDefinitions::PostgresSchema)
    end
  end
  describe Arc::DataStores::ObjectDefinitions::PostgresColumn, :wip => true do
    it 'returns a time type' do
      c = Arc::DataStores::ObjectDefinitions::PostgresColumn.new(nil,
        :type => "time without time zone"
      )
      stype = c.instance_variable_get :@stype
      stype.should == "time without time zone"
      c.type.should == :time
    end    
  end
end