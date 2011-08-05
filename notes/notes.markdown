Interactions between arel and ActiveRecord
	Type Conversion/Quoting:
		Arel::Visitors::ToSql
			#quote -> connection_pool.with_connection.quote
			#quote_table_name -> connection_pool.quote_table_name
			#quote_column_name -> connection_pool.quote_column_name
		Arel::Visitors
			#visitor_for -> connection_pool.spec.config[:adapter]
		Arel::Table
		  #primary_key -> engine.connection.primary_key
		  #columns