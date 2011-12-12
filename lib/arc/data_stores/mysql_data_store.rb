require 'mysql2'
Mysql2::Client.default_query_options.merge!({
  :symbolize_keys => true
})

module Arc::DataStores
  class MysqlDataStore < AbstractDataStore
    
    def read query
      execute(query)
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

    def execute query
      with_store do |store|
        store.query query
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
