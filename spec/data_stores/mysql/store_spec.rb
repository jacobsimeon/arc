require 'spec_helper'
require 'arc/data_stores/mysql/store'

describe Arc::DataStores::MysqlDataStore do
  describe "#schema" do
    it 'is an instance of Arc::DataStores::MysqlSchema' do
      store = Arc::DataStores::MysqlDataStore.new ArcTest.config[:mysql]
      store.schema.should be_a(Arc::DataStores::ObjectDefinitions::MysqlSchema)
    end
  end
end