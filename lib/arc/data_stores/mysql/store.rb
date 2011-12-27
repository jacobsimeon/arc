require 'mysql2'
require 'arc/data_stores/mysql/object_definitions'

Mysql2::Client.default_query_options.merge!({
  :symbolize_keys => true
})

module Arc::DataStores
  class MysqlDataStore < AbstractDataStore
    
    def read query
      case query
      when String
        execute(query).entries
      when Arel::SelectManager
        result_for query
      end
    end
    
    def create sql
      table = sql.match(/\AINSERT into ([^ (]*)/i)[1]
      execute sql
      read("select * from #{table} where id = " + last_row_id.to_s).first
    end
    
    def update sql
      execute sql
    end
    
    def destroy sql
      execute sql
    end
    
    def quote_column_name table
      "`#{table}`"
    end
    alias :quote_column :quote_column_name

    def execute query
      with_store do |store|
        store.query query
      end
    end
    
    def schema
      @schema ||= ObjectDefinitions::MysqlSchema.new self
    end
    
    def cast_blob data
      debugger
      data
    end
    def quote_blob data
      with_store do |store|
        "'#{store.escape(data).force_encoding("BINARY")}'"
      end
    end
    
    private
    def create_connection
      Mysql2::Client.new @config
    end
    
    def last_row_id
      with_store do |store|
        store.last_id
      end
    end
          
  end
end
