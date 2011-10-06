module Arc
  module Schemas
    class SqliteSchema < Schema
      
      def fetch_keys
        r = @data_store.read <<-SQL
          SELECT name FROM sqlite_master
          WHERE type='table';
        SQL
        r.map{ |t| t[:name].to_sym }
      end
      
      def fetch_item name
        # @data_store.read <<-SQL
        #   PRAGMA table_info('#{name}')
        # SQL
      end
    end
    
    class SqliteSchema::SqliteTable < Schema::Table
      def fetch_column_names
        
      end
      def fetch_column column_name
        
      end
    end
    
    class SqliteSchema::SqliteTable::SqliteColumn < Schema::Table::Column
      def type
        
      end
    end

  end
end
