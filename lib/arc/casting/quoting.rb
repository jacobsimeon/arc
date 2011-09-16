require 'date'
require 'bigdecimal'

module Arc
  module Quoting
    class CannotCastValueError < StandardError; end
    # Quotes the column name. Defaults to no quoting.
    def quote_column_name(column_name)
      column_name
    end

    # Quotes the table name. Defaults to column name quoting.
    def quote_table_name(table_name)
      quote_column_name(table_name)
    end
          
    def quote(value, klass=value.class)
      case klass
      when String, Symbol
        method = "quote_#{klass.to_s}"
        return send method, value
      else
        while klass.name do
          method = "quote_#{klass.name.downcase.gsub(/class/,'')}"
          return send method, value if respond_to? method, :include_private => true
          klass = klass.superclass
        end
      end
      raise CannotCastValueError, "Unable to cast #{value}"
    end
    
    private
    # Quotes a string, escaping any ' (single quote) and \ (backslash)
    # characters.
    def quote_symbol s
      quote_string s.to_s
    end
    def quote_string(s)
      "'#{s.gsub(/\\/, '\&\&').gsub(/'/, "''")}'"
    end
    def quote_true value=true
      quote_string 't'
    end
    def quote_false value=false
      quote_string 'f'
    end
    def quote_date(value)
      return quote_string value if value.is_a? String
      quote_string "#{value.strftime '%Y-%m-%d'}"
    end
    def quote_time value
      return quote_string value if value.is_a? String
      quote_string "#{value.strftime '%Y-%m-%d %H:%M:%S'}"
    end
    def quote_numeric value
      value.to_s
    end
    def quote_bigdecimal value
      return value if value.is_a? String
      value.to_s 'F'
    end
    def quote_nil(value=nil)
      'NULL'
    end
    def quote_binary value
      value.gsub!(/\0|\%/n) do |byte|
        case byte
          when "\0" then "%00"
          when '%'  then "%25"
        end
      end
      quote_string value        
    end
  end
end
