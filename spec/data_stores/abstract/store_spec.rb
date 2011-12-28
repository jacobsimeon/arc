require 'spec_helper'

module Arc
  module DataStores
    describe AbstractDataStore do
      before :each do
        @store = AbstractDataStore.new ArcTest.config[:empty]
        @query = "omg"
        @sstore = Arc::DataStores[:sqlite].new ArcTest._config[:sqlite]
        @sstore.schema.execute_ddl File.read("spec/support/schemas/sqlite.sql")
        Arel::Table.engine = @sstore
      end
      
      it 'proxies methods to the schema' do
        store = AbstractDataStore.new({})
        schema = ObjectDefinitions::Schema.new(store)
        schema.stub(:[]).and_return(ObjectDefinitions::Table.new :fake_table)
        store.stub!(:schema).and_return(schema)
        store[:fake_table].should be_a(ObjectDefinitions::Table)
      end
      
      it 'includes arel compatibility' do
        @store.should be_a(ArelCompatibility)
      end
      
      it 'includes quoting module' do
        @store.should be_a(Arc::Quoting)
      end
      
      describe '#new' do
        it 'does not define connection creation' do
          store = AbstractDataStore.new ArcTest.config[:sqlite]
          ->{ store.send :with_store }.should raise_error(NotImplementedError)
        end
      end
    
      describe 'abstract methods throw NotImplementedError' do
        it '#schema raises not implemented error' do
          ->{ @store.schema }.should raise_error(NotImplementedError)
        end
        it '#create raises not implemented error' do
          ->{ @store.create @query }.should raise_error(NotImplementedError)
        end
        it '#read raises not implemented error' do
          ->{ @store.read @query }.should raise_error(NotImplementedError)          
        end
        it '#update raises not implemented error' do
          ->{ @store.update @query }.should raise_error(NotImplementedError)          
        end
        it '#destroy raises not implemented error' do
          ->{ @store.destroy @query }.should raise_error(NotImplementedError)          
        end
        it '#execute raises not implemented error' do
          ->{ @store.execute @rquery }.should raise_error(NotImplementedError)          
        end
      end
      
      describe '#type_mappings_for' do
        it '#converts data store data types (varchar, tinyint, etc) into ruby types (string, integer, etc)' do
          superheros = Arel::Table.new :superheros
          query = superheros.project(
            superheros[:name],
            superheros[:born_on],
            superheros[:photo],
            superheros[:created_at]
          )
          @sstore.type_mappings_for(query).should == {
            :name => :varchar,
            :born_on => :date,
            :photo => :binary,
            :created_at => :time
          }
        end
      
        it '#handles aliased tables' do
          superheros = Arel::Table.new :superheros
          superheros_1 = superheros.alias
          query = superheros.project(
            superheros_1[:name],
            superheros_1[:born_on],
            superheros_1[:photo],
            superheros_1[:created_at]
          )
          @sstore.type_mappings_for(query).should == {
            :name => :varchar,
            :born_on => :date,
            :photo => :binary,
            :created_at => :time            
          }
        end
        
        it '#handles aliased columns (attributes)' do
          superheros = Arel::Table.new :superheros
          superheros_1 = superheros.alias
          query = superheros.project(
            superheros_1[:name].as('superhero_name'),
            superheros_1[:born_on],
            superheros_1[:photo],
            superheros_1[:created_at]
          )
          @sstore.type_mappings_for(query).should == {
            :superhero_name => :varchar,
            :born_on => :date,
            :photo => :binary,
            :created_at => :time            
          }
        end
        
        it '#handles complex joins' do
          powers = Arel::Table.new :powers
          superheros_powers = Arel::Table.new :superheros_powers
          superheros = Arel::Table.new :superheros

          superheros_powers = superheros_powers.alias
          powers = powers.alias

          stmt = superheros
          .join(superheros_powers).on(
            superheros_powers[:superhero_id].eq(superheros[:id])
          )
          .join(powers).on(
            powers[:id].eq(superheros_powers[:power_id])
          )
          .project(
            superheros[:name].as('superhero_name'),
            superheros[:created_at].as("hello"),
            powers[:name].as("power_name")
          )
          .where(
            superheros[:id].eq(1)
          )
          
          @sstore.type_mappings_for(stmt).should == {
            :superhero_name => :varchar,
            :hello => :time,
            :power_name => :varchar
          }
        end
      end
      
      describe '#result_for' do
        it 'creates a lazy loaded array whose elements are lazy loaded hashes whose values are type-casted query results' do
          Arel::Table.engine = @sstore
          load "spec/support/seed.rb"
          superheros = Arel::Table.new :superheros
          query = superheros.project(
            superheros[:name],
            superheros[:born_on],
            superheros[:photo],
            superheros[:created_at]
          )
          result = @sstore.result_for query
          result.should be_an(Array)
          result[0].should be_a(Hash)
          result[0][:born_on].should be_a(Date)
          result[0][:created_at].should be_a(Time)
        end
      end
      
    end
  end
end
    
    