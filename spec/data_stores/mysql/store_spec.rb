require 'spec_helper'
require 'arc/data_stores/mysql/store'

describe Arc::DataStores::MysqlDataStore do
  before :each do
    @store = Arc::DataStores[:mysql].new ArcTest.config[:mysql]    
  end
  
  it 'saves binary data', :wip => true do
    Arel::Table.engine = @store
    load "spec/support/seed.rb"
    superheros = Arel::Table.new :superheros
    result = @store.read superheros.project(superheros[:photo]).where(superheros[:name].eq("superman"))
    result[0][:photo].should_not be_nil
    result[0][:photo].should == File.read("spec/support/resources/superman.gif").force_encoding("BINARY")
    File.open("spec/support/resources/out/superman.gif", "w+"){ |f| f.write result[0][:photo] }
  end
  
  describe "#schema" do
    it 'is an instance of Arc::DataStores::MysqlSchema' do
      @store.schema.should be_a(Arc::DataStores::ObjectDefinitions::MysqlSchema)
    end
  end
  
  describe '#quote' do
    it 'quotes table names' do
      @store.quote_table_name('my-table').should == "`my-table`"
    end
    it 'quotes column names' do
      @store.quote_column_name('my-column').should == "`my-column`"
    end
    it 'quotes dates' do
      date = Date.parse '2012-01-01'
      quoted_date = @store.quote date
      quoted_date.should == "'2012-01-01'"
    end
    it 'quotes a time' do
      time = Time.parse '2012-01-01 12:30:21 -0700'
      quoted_time = @store.quote time
      quoted_time.should == "'2012-01-01 12:30:21'"
    end
  end
  
  describe '#cast' do
    it 'casts a date' do
      date = Date.parse '2012-01-01'
      casted_date = @store.cast date, :date
      casted_date.should be_a(Date)
      casted_date.should == Date.parse('2012-01-01')
    end
  end
    
end