require 'spec_helper'

module Arc
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
        quoter.quote("my%String", String).should == "'my%String'"
      end
      it 'quotes a date object' do
        date = Date.today
        fmt = '%Y-%m-%d'
        quoter.quote(date).should == "'#{date.strftime fmt}'"
        quoter.quote(date.strftime(fmt), Date).should == "'#{date.strftime fmt}'"
      end
      it 'quotes a time object' do
        time = Time.now
        fmt = '%Y-%m-%d %H:%M:%S'
        quoter.quote(time).should == "'#{time.strftime fmt}'"
        quoter.quote(time.strftime(fmt), Time).should == "'#{time.strftime fmt}'"
      end
      it 'quotes a fixnum' do
        fixnum = 10
        quoter.quote(fixnum).should == fixnum.to_s
        quoter.quote(fixnum.to_s, Fixnum).should == fixnum.to_s          
      end
      it 'quotes a bignum' do
        bignum = 1<<100
        quoter.quote(bignum).should == bignum.to_s
        quoter.quote(bignum.to_s, Bignum).should == bignum.to_s
      end
      it 'quotes a float' do
        float = 1.2
        quoter.quote(float).should == float.to_s
        quoter.quote(float, Float).should == float.to_s
      end
      it 'quotes a bigdecimal' do
        big_decimal = BigDecimal.new((1 << 100).to_s)
        quoter.quote(big_decimal).should == big_decimal.to_s('F')
        quoter.quote(big_decimal.to_s('F'), BigDecimal).should == big_decimal.to_s('F')
      end
      it 'quotes nil' do
        quoter.quote(nil).should == 'NULL'
        quoter.quote('NULL', NilClass).should == 'NULL'
        quoter.quote(nil, NilClass).should == 'NULL'
      end
      it 'quotes true' do
        quoter.quote(true).should == "'t'"
        quoter.quote('true', TrueClass).should == "'t'"
      end
      it 'quotes false' do
        quoter.quote(false).should == "'f'"
        quoter.quote('false', FalseClass).should == "'f'"
      end
      it 'escapes and quotes a binary string' do
        quoter.quote("\0%", :binary).should == "'%00%25'"
      end
    end  
  end
end