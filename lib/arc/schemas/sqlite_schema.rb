module Arc
  module Schemas
    class SqliteSchema < Schema
      def fetch_keys
        r = @data_store.read <<-SQL
          SELECT name FROM sqlite_master
          WHERE type='table' AND name != 'sqlite_sequence';
        SQL
        r.map{ |t| t[:name].to_sym }
      end
      
      def fetch_item name
        SqliteTable.new name, @data_store
      end
    end
    
    class SqliteSchema::SqliteTable < Schema::Table
      def raw_column_data
        @rcd ||= @data_store.read <<-SQL
          PRAGMA table_info('#{@name}');        
        SQL
      end
      def fetch_keys
        raw_column_data.map { |c| c[:name].to_sym }
      end
      def fetch_item column_name
        c = raw_column_data.select {|c| c[:name] == column_name.to_s }.first
        c = {
          name: c[:name],
          allows_null: c[:notnull] == 0,
          default: c[:dflt_value],
          primary_key: c[:pk] == 1,
          type: c[:type]
        }
        SqliteColumn.new @data_store, c
      end
    end
    
    class SqliteSchema::SqliteTable::SqliteColumn < Schema::Table::Column
      def type
        #simplify the type expression to remove length and precision
        @type ||= @stype.downcase.gsub(/\([\d,]*\)/, '').to_sym
      end
    end

  end
end
