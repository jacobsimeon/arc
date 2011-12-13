require 'spec_helper'

module Arc
  module DataStores
    describe AbstractDataStore do
      before :each do
        @store = AbstractDataStore.new ArcTest.config[:empty]
        @query = "omg"
      end
      
      it 'proxies methods to the schema' do
        store = AbstractDataStore.new({})
        schema = ObjectDefinitions::Schema.new(store)
        schema.stub(:[]).and_return(ObjectDefinitions::Schema::Table.new :fake_table)
        store.stub!(:schema).and_return(schema)
        store[:fake_table].should be_a(ObjectDefinitions::Schema::Table)
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
    end
  end
end
    
    