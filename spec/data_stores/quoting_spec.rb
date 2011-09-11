require 'spec_helper'

module Arc
  module DataStores
    describe Quoting do
      describe '#quote' do
        
        def quoter
          @quoter ||= Class.new { include Quoting }.new
        end
        
        it 'should throw an exception if it cannot find a convertible class' do
          ->{ quoter.quote(Class.new.new) }.should raise_error(Quoting::CannotCastValueError)
        end
        it 'should wrap the symbol using single quotes' do
          quoter.quote(:superman).should == "'superman'"
          quoter.quote('superman', Symbol).should == "'superman'"
        end
        it 'quotes a string' do
          quoter.quote("\\").should == "'\\\\'"
          quoter.quote("'").should == "''''"
        end
        it 'should quote a date object' do
          date = Date.today
          fmt = '%Y-%m-%d'
          quoter.quote(date).should == "'#{date.strftime fmt}'"
          quoter.quote(date.strftime(fmt), Date).should == "'#{date.strftime fmt}'"
        end
        it 'should quote a time object' do
          time = Time.now
          fmt = '%Y-%m-%d %H:%M:%S'
          quoter.quote(time).should == "'#{time.strftime fmt}'"
          quoter.quote(time.strftime(fmt), Time).should == "'#{time.strftime fmt}'"
        end
        it 'should quote a fixnum' do
          fixnum = 10
          quoter.quote(fixnum).should == fixnum.to_s
          quoter.quote(fixnum.to_s, Fixnum).should == fixnum.to_s          
        end
        it 'should quote a bignum' do
          bignum = 1<<100
          quoter.quote(bignum).should == bignum.to_s
          quoter.quote(bignum.to_s, Bignum).should == bignum.to_s
        end
        it 'should quote a float' do
          float = 1.2
          quoter.quote(float).should == float.to_s
          quoter.quote(float, Float).should == float.to_s
        end
        it 'should quote a bigdecimal' do
          big_decimal = BigDecimal.new((1 << 100).to_s)
          quoter.quote(big_decimal).should == big_decimal.to_s('F')
          quoter.quote(big_decimal.to_s('F'), BigDecimal).should == big_decimal.to_s('F')
        end
        it 'should quote nil' do
          quoter.quote(nil).should == 'NULL'
          quoter.quote('NULL', NilClass).should == 'NULL'
          quoter.quote(nil, NilClass).should == 'NULL'
        end
        it 'should quote true' do
          quoter.quote(true).should == "'t'"
          quoter.quote('true', TrueClass).should == "'t'"
        end
        it 'should quote false' do
          quoter.quote(false).should == "'f'"
          quoter.quote('false', FalseClass).should == "'f'"
        end    
      end  
    end
  end
end