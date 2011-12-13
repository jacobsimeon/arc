module Arc
  module Casting
    class CannotCastValueError < StandardError; end
        
    TYPES = { 
      integer:  'integer',
      int:      'integer',
      char:     'string' ,
      varchar:  'string' ,
      binary:   'binary' ,
      date:     'date'   ,
      datetime: 'time'   ,
      time:     'time'   ,
      bool:     'boolean',
      boolean:  'boolean', 
      bit:      'boolean',
      float:    'float'  ,
    }
    
    CAST_METHODS = Hash.new do |cast_methods, key|
      method = "cast_#{TYPES[key.to_sym]}"
      cast_methods[key] = method 
    end
      
    def cast value, type
      method = CAST_METHODS[type]
      return send method, value if respond_to? method, :include_private
      return cast_string value
    end
  
    private
    def cast_string value
      value.to_s
    end
    def cast_integer value
      value.to_i
    end
    def cast_float value
      value.to_f
    end
    def cast_time value
      Time.parse value
    end
    def cast_date value
      Date.parse value
    end
    def cast_binary value
      value.to_s.force_encoding "BINARY"
      value.gsub!(/%00|%25|\\\\/n) do |byte|
        case byte
          when "%00"  then "\0"
          when "%25"  then "%"
          when "\\\\" then "\\"
        end
      end
    end
    def cast_boolean value
      case value
      when true, 1, '1', 'true', 't'
        true
      when false, 0, '0', 'false', 'f'
        false
      end
    end
  end
end