require 'arc/data_stores/abstract/object_definitions'

module Arc
  module DataStores
    module ObjectDefinitions
    
      class PostgresSchema < Schema
        def fetch_keys
          names = @data_store.read("select tablename from pg_tables where schemaname = ANY(current_schemas(false))")
          names = names.to_a.map { |n| n[:tablename].to_sym }
        end
        def fetch_item name
          PostgresTable.new name, @data_store
        end
      end

      class PostgresTable < Table
        def raw_column_data
          column_info_query = <<-SQL
            SELECT  col.attrelid::regclass as table,
                    col.attname as name,
                    format_type(col.atttypid, col.atttypmod) as type,
                    col.attnotnull as not_null,
                    def.adsrc as default,
                    ( SELECT d.refobjid
                      FROM pg_depend d
                      WHERE col.attrelid = d.refobjid
                      AND col.attnum = d.refobjsubid
                      LIMIT 1
                    ) IS NOT NULL as primary_key
            FROM pg_attribute as col
            LEFT JOIN pg_attrdef def
              ON col.attrelid = def.adrelid
              AND col.attnum = def.adnum
            JOIN pg_tables tbl
              ON col.attrelid::regclass = tbl.tablename::regclass
            WHERE tbl.schemaname = ANY (current_schemas(false))
              AND col.attnum > 0
              AND tbl.tablename = '#{name}'
            ORDER BY primary_key DESC
          SQL
          @data_store.read(column_info_query).to_a.symbolize_keys!
        end
        def fetch_keys
          raw_column_data.map {|c| c[:name].to_sym }
        end      
        def fetch_item name
          return {} unless keys.include? name.to_sym
          c = raw_column_data.find{|c| c[:name] == name.to_s}
          PostgresColumn.new @data_store,{
            name: c[:name],
            allows_null: c[:not_null] == "f",
            default: nil,
            primary_key: c[:primary_key] == "t",
            type: c[:type]
          }
        end
      end

      class PostgresColumn < Column
        def type
          return :varchar if @stype =~ /character varying/
          return :time if @stype =~ /timestamp/
          @stype.to_sym
        end
      end

    end
  end
end
