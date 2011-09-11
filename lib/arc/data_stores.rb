require 'arc/data_stores/quoting'
require 'arc/data_stores/abstract_data_store'
module Arc
  module DataStores
    class AdapterNotFoundError < StandardError; end
    class AdapterNotSpecifiedError < StandardError; end
    
    STORES = {}
    
    class << self
      def create_store config
        if config[:adapter].nil?
          m = "Unable to determine adapter for data store - adapter not specified!"
          raise AdapterNotSpecifiedError, m
        end
        self[config[:adapter]].new config
      end
      
      def [](adapter)
        adapter = adapter.to_sym if adapter.is_a? String
        return STORES[adapter] unless STORES[adapter].nil?
        begin
          require "arc/data_stores/#{adapter}_data_store"
          STORES[adapter] = const_get "#{adapter.to_s.capitalize}DataStore"
        rescue LoadError
          m = "Unable to find #{adapter} adapter, make sure it is in your load path"
          raise AdapterNotFoundError, m
        end
      end
      
    end
  end
end