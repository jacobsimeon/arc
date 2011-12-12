require 'yaml'
require 'arel'

module Arel
  module Visitors
    VISITORS['postgres'] = VISITORS['postgresql']
  end
end

module Arc
  module DataStores
    module ArelCompatibility
      # tell arel how we'll be using it today
      def visitor
        Arel::Visitors.for self
      end
      def table_exists? name
        !self[name.to_sym].nil?
      end
      # hashes, imo, have no business in a sql database
      # add ability to quote a hash here to keep arel tests passing
      def quote_hash h
        quote_string h.to_yaml
      end
      # provide a method for getting at the primary key of a given table
      def primary_key table
        return nil unless table
        table = self[table]
        pk = table.column_names.find{ |c| table[c].primary_key? }
      end
      # the interface for each of these methods is already implemented by the existing class
      # just return self
      def columns_hash
        self
      end
      def connection
        self
      end
      def connection_pool
        self
      end
      def spec
        self
      end
      def with_connection
        yield self
      end
    end
  end
end