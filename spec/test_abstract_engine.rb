require 'spec_helper'

describe Arc::AbstractEngine do
  describe '#new' do
    it 'creates a new instance' do
      Arc::AbstractEngine.new.should be_an Arc::AbstractEngine  
    end
  end
end