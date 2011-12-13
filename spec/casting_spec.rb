require 'spec_helper'

module Arc
  describe Casting do
    before :all do
      @caster = Class.new { include Casting }.new
    end    
    describe '#cast' do
      
      it 'casts a string to an integer' do
        value = @caster.cast "1", :integer
        value.should == 1
        value = @caster.cast "1", :int
        value.should == 1
      end
      
      it 'casts a string to a float' do
        value = @caster.cast "1.1", :float
        value.should == 1.1
      end
      
      it 'casts a string to a time' do
        time = Time.now.round(0)
        value = @caster.cast time.to_s, :time
        value.should == time
        value = @caster.cast time.to_s, :datetime
        value.should == time        
      end
      
      it 'casts a string to a date' do
        date = Date.today
        value = @caster.cast date.to_s, :date
        value.should == date
      end
      
      it 'unescapes binary data' do
        binary = "%25%00\\\\"
        value = @caster.cast binary, :binary
        value.should == "%\0\\"
      end
      
      it "casts 'true'" do
        truths = ['true', true, 't', '1', 1]
        truths.each do |truth|
          value = @caster.cast truth, :bool
          value.should be_true
          value = @caster.cast truth, :boolean
          value.should be_true 
          value = @caster.cast true, :bit
          value.should be_true
        end
      end
      
      it "casts 'false'" do
        lies = ['false', false, 'f', '0', 0]
        lies.each do |lie|
          value = @caster.cast lie, :bool
          value.should be_false
          value = @caster.cast lie, :boolean
          value.should be_false 
          value = @caster.cast lie, :bit
          value.should be_false 
        end
      end
      
      it 'defaults to string if no casting method is found' do
        value = @caster.cast 'superman', :awesome
        value.should == 'superman'
      end
      
    end
  end
end