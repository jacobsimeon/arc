require 'spec_helper'
require 'arc/data_stores/sqlite/store'

describe Arc::DataStores::SqliteDataStore do
  describe "#schema" do
    it 'is an instance of Arc::DataStores::SqliteSchema' do
      store = Arc::DataStores::SqliteDataStore.new(:database => ":memory:")
      store.schema.should be_a(Arc::DataStores::ObjectDefinitions::SqliteSchema)
    end
  end
end