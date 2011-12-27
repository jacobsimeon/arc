require 'spec_helper'
require 'arc/data_stores/postgres/store'

describe Arc::DataStores::PostgresDataStore do
  before :each do
    @store = Arc::DataStores[:postgres].new ArcTest.config[:postgres]
    ddl = File.read "spec/support/schemas/postgres.sql"
    @store.schema.execute_ddl ddl
  end
  
  after :each do
    drop_ddl = File.read "spec/support/schemas/drop_postgres.sql"
    @store.schema.execute_ddl @drop_ddl
    @schema_loaded = false
  end
  
  describe "#schema" do
    it 'is an instance of Arc::DataStores::PostgresSchema' do
      store = Arc::DataStores[:postgres].new ArcTest.config[:postgres]
      store.schema.should be_a(Arc::DataStores::ObjectDefinitions::PostgresSchema)
    end
  end
  describe Arc::DataStores::ObjectDefinitions::PostgresColumn do
    it 'returns a time type' do
      c = Arc::DataStores::ObjectDefinitions::PostgresColumn.new(nil,
        :type => "time without time zone"
      )
      stype = c.instance_variable_get :@stype
      stype.should == "time without time zone"
      c.type.should == :time
    end    
  end
  it 'can save binary data' do
    Arel::Table.engine = @store
    load "spec/support/seed.rb"
    superheros = Arel::Table.new :superheros
    result = @store.read superheros.project(superheros[:photo]).where(superheros[:name].eq("superman"))
    result[0][:photo].should_not be_nil
    result[0][:photo].should == File.read("spec/support/resources/superman.gif").force_encoding("BINARY")
    File.open("spec/support/resources/out/superman.gif", "w+"){ |f| f.write result[0][:photo] }    
  end
end