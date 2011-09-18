require 'spec_helper'

module Arc
  module Schemas
    describe "All the Schemas!" do
      before :all do
        ArcTest.load_schema
      end
      after :all do
        ArcTest.drop_schema
      end
      it 'has a superheros table' do
        ArcTest.store.schema.table_names.should include(:superheros)
        ArcTest.store.schema[:superheros].should be_a(Schema::Table)
      end
    end
  end
end