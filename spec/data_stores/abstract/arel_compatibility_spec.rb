require 'spec_helper'

module Arc
  module DataStores
    describe ArelCompatibility do

      before :all do
        @s = ArcTest.get_store
      end

      it '#responds to #connection_pool#spec#config' do  
        @s.connection_pool.spec.config[:adapter].should == ArcTest.adapter.to_s
      end
      it 'responds to #with_connection and yields an object which has an execute method' do        
        @s.with_connection do |connection|
          connection.should respond_to(:execute)
        end
      end
      it 'provides a visitor at #connection.visitor' do
        @s.stub!(:visitor).and_return("lol")
        @s.connection.visitor.should == "lol"
      end
      it "aliases #quote_table to #quote_table_name" do
        @s.method(:quote_table).should == @s.method(:quote_table_name)
      end
      it 'aliases quote_column to #quote_column_name' do
        @s.method(:quote_column).should == @s.method(:quote_column_name)
      end
      it 'provides a table_exists? method' do
        @s.table_exists?(:superheros).should be_true
      end
      it 'provides a hashlike object at #connection_pool.columns_hash' do
        @s.connection_pool.columns_hash.should be(@s)
      end
      it 'responds to primary_key given a table name' do
        @s.connection.primary_key(:superheros).should be(:id)
      end
      it 'should quote a hash' do
        hash = {:a => :b}
        @s.quote_hash(hash).should == "'#{hash.to_yaml}'"
      end
      
    end
  end
end