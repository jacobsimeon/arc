require 'spec_helper'

describe Arc::Engine do
  describe '#new' do
    it 'creates a new instance' do
      engine = Arc::Engine.new({
        :adapter => :sqlite,
        :database => :test_db
      })
      engine.should be_an Arc::AbstractEngine
      engine.tabls
    end
    
    
    
    
  end
end