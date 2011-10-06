require 'spec_helper'

module Arc
  module Schemas
    describe "All the Schemas!" do
      it 'has a superheros table' do
        ArcTest.with_store do |store|

          store.schema.table_names.should include(:superheros)            
          heros = store.schema[:superheros]
          heros.should be_a(Schema::Table)
          heros.column_names.should include(:id)
          heros.column_names.should include(:name)

          #id column
          id = heros[:id]
          id.should be_a(Schema::Table::Column)
          id.pk?.should be_true
          id.allows_null?.should be_false
          id.default.should be_nil
          id.name.should == "id"
          id.type.should == :integer
          
          #name column
          name = heros[:name]
          name.should be_a(Schema::Table::Column)
          name.pk?.should be_false
          name.allows_null?.should be_false
          name.default.should be_nil
          name.name.should == "name"
          name.type.should == :varchar
          
        end
      end

    end
  end
end