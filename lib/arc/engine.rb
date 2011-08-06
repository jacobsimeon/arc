module Arc
  class Engine
    
    def initialize(config, klass=Reactor)
      @klass, @config = klass, config
      Arc::ConnectionHandler.add_connection @klass, @config      
    end
    
    def to_h
      #contains a hash for each table with an array of column names and column objects
      #ex:
      # {
      #   :users => {
      #     :id => id_column,
      #     :name => name_column
      #   },
      #   :products => {
      #     :id => id_column,
      #     :price => price_column
      #   }
      # } 
    end
    alias :to_hash
    
    def adapter
      #the adapter for arel to use, so it can work around inconsistencies in different databases
    end
    
    def primary_key name
      #get the primary key column object for the passed table name
    end
    
    def table_exists? name
      #true if the table exists in the database
    end
    
    def tables
      @tables
    end
    
    def quote_table_name name
      #wrap the table name in quotes
    end

    def quote_column_name name
      #wrap the column name in quotes
    end

    def quote thing, column = nil
      #return the passed value as a string
      #should wrap in proper quotes based on data type
    end
    
    def create query
      #add new data
    end
    
    def read query
      #read existing data
    end
    
    def update query
      #update existing data
    end
    
    def destroy query
      #destroy existing data
    end

    private
    def connection
      Arc::ConnectionHandler.connection_for @klass
    end

    def execute query
      #run an operation
    end
    
  end
end

