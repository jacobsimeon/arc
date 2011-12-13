require 'spec_helper'
require 'arc/data_stores/abstract/object_definitions'

module Arc
  module DataStores
    module ObjectDefinitions
      describe ObjectDefinitions do
        before :each do
          @store = AbstractDataStore.new ArcTest.config[:empty]
        end

        describe Schema do
          it 'includes Collector' do
            Schema.included_modules.should include(Collector)
          end
          it 'aliases item_names to table_names' do
            schema = Schema.new nil
            schema.should respond_to(:table_names)
          end
        end

        describe Table do
          it 'includes Collector' do
            Table.included_modules.should include(Collector)
          end
          it 'aliases item_names to column_names' do
            table = Table.new nil, :superheros
            table.should respond_to(:column_names)
          end
          describe '#new' do
            it 'has a name' do
              Table.new('superheros').name.should == 'superheros'
            end
            it 'sets the data store' do                        
              Table.new('superheros', @store).instance_variable_get(:@data_store).should be(@store)
            end
          end
        end

        describe "Schema::Table::Column#new" do
          it 'sets the datastore' do
            c = Column.new @store
            c.instance_variable_get(:@data_store).should be(@store)
          end
          it "sets the column's name" do
            c = Column.new nil, :name => :superheros
            c.name.should == :superheros
          end
          it "sets the column's allows_null" do
            c = Column.new nil, :allows_null => false
            c.allows_null?.should == false
          end
          it "sets the column's default value" do
            c = Column.new nil, :default => "superman"
            c.default.should == "superman"
          end
          it "sets the column's primary_key?" do
            c = Column.new nil, :primary_key => true
            c.pk?.should be_true
            c.primary_key?.should be_true
          end
          it "sets the string representation of the column's type" do
            c = Column.new nil, :type => "INTEGER"
            c.instance_variable_get(:@stype).should == "INTEGER"
          end
          it 'throws NotImplementedError when querying type' do
            c = Column.new nil
            ->{ c.type }.should raise_error(NotImplementedError)
          end
        end

      end
    end
  end
end