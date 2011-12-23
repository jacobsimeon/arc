require 'spec_helper'
require 'arc/data_stores/mysql/store'

describe Arc::DataStores::MysqlDataStore do
  describe '#quote_table_name', :wip => true do
    store = Arc::DataStores::MysqlDataStore.new ArcTest.config[:mysql]
    store.quote_table_name('my-table').should == "`my-table`"
  end
  describe '#quote_column_name', :wip => true do
    store = Arc::DataStores::MysqlDataStore.new ArcTest.config[:mysql]
    store.quote_column_name('my-column').should == "`my-column`"    
  end
  
  describe "#schema" do
    it 'is an instance of Arc::DataStores::MysqlSchema' do
      store = Arc::DataStores::MysqlDataStore.new ArcTest.config[:mysql]
      store.schema.should be_a(Arc::DataStores::ObjectDefinitions::MysqlSchema)
    end
  end
end