module Arc
  module Schemas
    class SqliteSchema < Schema
          
      def fetch_item_names
        # r = @data_store.read <<-SQL
        #   SELECT name FROM sqlite_master
        #   WHERE type='table';
        # SQL
        # r.map do |t|
        #   t[:name].to_sym
        # end
      end
      
      def fetch_item name
        # @data_store.read <<-SQL
        #   PRAGMA table_info('#{name}')
        # SQL
      end

      class SqliteTable < Table
        def fetch_column_names
          
        end
        def fetch_column column_name
          
        end
          
        class SqliteColumn < Column
          def type
            
          end
        end
      end
          
    end
  end
end
