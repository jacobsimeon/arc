Interactions between arel and ActiveRecord
	Type Conversion/Quoting:
		Arel::Visitors::ToSql
			#quote -> connection_pool.with_connection.quote
			#quote_table_name -> connection_pool.quote_table_name
			#quote_column_name -> connection_pool.quote_column_name
			#table_exists? -> connection_pool.table_exists?
			#column_cache -> connection_pool.columns_hash
		Arel::Visitors
			#visitor_for -> connection_pool.spec.config[:adapter]
		Arel::Table
		  #primary_key -> engine.connection.primary_key
		  #columns
		Arel::Crud
		  #update -> engine.connection.update
		  #delete -> engine.connection.delete
		  #insert -> engine.connection.insert
		  
      module Arc

        #single instance that dispatches connections for the corresponding classes
        class ConnectionHandler

          def self.add_connection(klass, config)
            connections[klass] = ConnectionPool.new(config) if connections[klass].nil?
          end

          def self.connections
            @@connections ||= {}
          end

          def self.connection_for klass
            connections[klass] unless connections[klass].nil?
          end

        end 

        #handles thread synchronization and creation of connection objects
        class ConnectionPool
          def initialize(config)
            #inspect config for adapter information
            #handle creation, check in and check out of connections
          end

          def check_in
          end

          def create_connection
            #inspect config for adapter
            #generate adapter connection object
          end

          def check_out
          end
        end

        class Reactor

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

