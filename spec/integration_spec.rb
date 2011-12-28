require 'spec_helper'

describe Arc do
  #thread safety
  #create a record
  #read a record
    #complex query
  #update a record
  #destroy a record
  
  #convenience method for building a tree of arel values
  def values_array table_name, hash
    hash.keys.map do |attr|
      [@tables[table_name][attr], hash[attr]]
    end
  end
  
  #grab a superhero record by name
  def get_hero(hero_name)
    query = @tables[:superheros]
      .project('*')
      .where(@tables[:superheros][:name].eq(hero_name))
      .to_sql
    @store.read query
  end
  
  before :all do
    @store = ArcTest.get_store
    @tables = Hash.new do |hash, key|
      hash[key] = Arel::Table.new key
    end
  end

  it "Safely executes queries initiated on different threads" do
    threads = []
    s = @tables[:superheros]
    query = s.project( s[:name] )
    result = @store.read(query)[0][:name]
    5.times do
      threads << Thread.start do
        Thread.current[:result] = @store.read(query)[0][:name]
      end
    end
    names = threads.map {|t| t.join; t[:result] }
    names.each {|n| n.should == result }
  end

  describe '#create and #read'  do
    before :each do
      Timecop.freeze Time.now do
        @created_at = Time.parse('2011-12-27 11:52:56 -0700')
        properties = {
          :name => "green hornet",
          :born_on => @created_at,
          :photo => File.read('spec/support/resources/ironman.gif'),
          :created_at => @created_at
        }
        im = Arel::InsertManager.new Arel::Table.engine
        im.insert values_array(:superheros, properties)
        @result = @store.create im
      end
    end
  
    it 'creates a new record' do
      superheros = @tables[:superheros]
      query = @tables[:superheros]
        .project(
          superheros[:name],
          superheros[:born_on],
          superheros[:created_at],
          superheros[:photo]
        )
        .where(@tables[:superheros][:name].eq('green hornet'))
      result = @store.read query
      result[0][:name].should == 'green hornet'
      result[0][:born_on].should == Date.today
      result[0][:created_at].should == @created_at
      result[0][:photo].should == File.read('spec/support/resources/ironman.gif').force_encoding("BINARY")
    end
  
    it 'returns the record with a populated primary key' do
      @result[:id].should_not be_nil
      @result[:name].should == 'green hornet'
      @result[:born_on].should == Date.today
    end
  
  end

  describe '#update' do
    it 'updates a record (and returns the updated record when passing an id)' do
      s = @tables[:superheros]
      stmt = s.project(s[:id]).where(s[:name].eq('megaman'))
      id = @store.read(stmt)[0][:id]
    
      properties = {:name => 'batman'}
      um = Arel::UpdateManager.new @store
      um.table @tables[:superheros]
      um.set(values_array(:superheros, properties))
        .where(@tables[:superheros][:name].eq('megaman'))
      result = @store.update um, id
      result[:name].should == 'batman'
      result[:born_on].should be_a(Date)
    
      megaman = get_hero('megaman')
      megaman.size.should == 0
      megaman.should be_a(Enumerable)
    
      batman = get_hero('batman')
      batman.size.should == 1
      batman.first[:name].should == 'batman'
    end
  end

  describe '#destroy' do
    it 'deletes a record' do 
      delete = Arel::DeleteManager.new @store
      delete
        .from(@tables[:superheros])
        .where(@tables[:superheros][:name].eq('superman'))
      @store.destroy delete
      superman = get_hero('superman')
      superman.size.should == 0
      superman.size.should == 0
      superman.should be_a(Enumerable)
    end
  end
end
