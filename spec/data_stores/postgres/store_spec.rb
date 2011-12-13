require 'spec_helper'
require 'arc/data_stores/postgres/store'

describe Arc::DataStores::PostgresDataStore do
  describe "#schema" do
    it 'is an instance of Arc::DataStores::PostgresSchema' do
      store = Arc::DataStores::PostgresDataStore.new ArcTest.config[:Postgres]
      store.schema.should be_a(Arc::DataStores::ObjectDefinitions::PostgresSchema)
    end
  end
end