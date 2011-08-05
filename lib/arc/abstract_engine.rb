module Arc
  class AbstractEngine
    
    attr_reader :tables, :columns_hash, :config
    
    def initialize config
    end
    
    def primary_key name
    end

    def table_exists? name
    end

    def columns name, message = nil
    end

    def quote_table_name name
    end

    def quote_column_name name
    end

    def quote thing, column = nil
    end
    
    private
    def connection_pool
    end
    
  end
end

