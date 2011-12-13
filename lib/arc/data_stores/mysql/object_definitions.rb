require 'arc/data_stores/abstract/object_definitions'

module Arc
  module DataStores
    module ObjectDefinitions
      class MysqlSchema < Schema
        def fetch_keys
          @data_store.read("SHOW TABLES").map do |r|
            r[r.keys.first].to_sym
          end
        end
      
        def fetch_item name
          MysqlTable.new name, @data_store
        end
      end
    
      class MysqlTable < Table
        def raw_column_data
          @data_store.read("SHOW FULL FIELDS FROM superheros").each do |r|
            r
          end
        end
        def fetch_keys
          raw_column_data.map {|c| c[:Field].to_sym }
        end
        def fetch_item name
          return {} unless keys.include? name.to_sym
          c = raw_column_data.find{|c| c[:Field] == name.to_s}
          MysqlColumn.new @data_store,{
            name: c[:Field],
            allows_null: c[:Null] == "YES",
            default: c[:Default],
            primary_key: c[:Key] == "PRI",
            type: c[:Type]
          }
        end
      end
    
      class MysqlColumn < Column
        TYPES = {
          :int => :integer,
        }
        def type
          @type ||= begin
            type_key = @stype.downcase.gsub(/\([\d,]*\)/, '').to_sym
            TYPES[type_key] || type_key
          end
        end
      end

    end
  end
end
