require 'spec_helper'

module Arc
  module Schemas
    describe Schema do
      
      it 'includes Collector' do
        Schema.included_modules.should include(Collector)
      end
      it 'aliases item_names to table_names' do
        schema = Schema.new nil
        schema.should respond_to(:table_names)
      end
      
      class Schema        
        describe Table do
          it 'includes Collector' do
            Table.included_modules.should include(Collector)
          end
          it 'aliases item_names to column_names' do
            table = Table.new nil, :superheros
            table.should respond_to(:column_names)
          end
        end
      end
      
      class Schema::Table
        describe Column do
          describe '#new' do
            it 'sets the datastore' do
              ArcTest.with_store do |store|
                c = Column.new store
                c.instance_variable_get(:@data_store).should be(store)
              end
            end
            it "sets the column's name" do
              c = Column.new nil, :name => :superheros
              c.name.should == :superheros
            end
            it "sets the column's allows_null" do
              c = Column.new nil, :allows_null => false
              c.allows_null.should == false
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
end