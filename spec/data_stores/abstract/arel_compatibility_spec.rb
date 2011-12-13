require 'spec_helper'

module Arc
  module DataStores
    describe ArelCompatibility do
      it '#specifies which arel visitor to use' do
        ArcTest.with_store do |s|
          Arel::Visitors.for s
        end
      end      
      it '#responds to #connection_pool#spec#config' do
        ArcTest.with_store do |s|
          s.connection_pool.spec.config[:adapter].should == ArcTest.config_key.to_s
        end
      end
      it 'responds to #with_connection and yields an object which has an execute method' do
        ArcTest.with_store do |s|
          s.with_connection do |connection|
            s.connection.should respond_to(:execute)
          end
        end
      end
      it 'provides a visitor at #connection.visitor' do
        ArcTest.with_store do |s|
          s.stub!(:visitor).and_return("lol")
          s.connection.visitor.should == "lol"
        end
      end
      it "aliases #quote_table to #quote_table_name" do
        ArcTest.with_store do |s|
          s.method(:quote_table).should == s.method(:quote_table_name)
        end
      end
      it 'aliases quote_column to #quote_column_name' do
        ArcTest.with_store do |s|
          s.method(:quote_column).should == s.method(:quote_column_name)
        end
      end
      it 'provides a table_exists? method' do
        ArcTest.with_store do |s|
          s.table_exists?(:superheros).should be_true
        end
      end
      it 'provides a hashlike object at #connection_pool.columns_hash' do
        ArcTest.with_store do |s|
          s.connection_pool.columns_hash.should be(s)
        end
      end
      it 'responds to primary_key given a table name' do
        ArcTest.with_store do |s|
          s.connection.primary_key(:superheros).should be(:id)
        end
      end
      it 'should quote a hash' do
        ArcTest.with_store do |s|
          hash = {:a => :b}
          s.quote_hash(hash).should == "'#{hash.to_yaml}'"
        end
      end
      
    end
  end
end