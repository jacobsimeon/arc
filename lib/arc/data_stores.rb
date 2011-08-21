require 'arc/data_stores/abstract_data_store'
module Arc
  module DataStores
    class AdapterNotFoundError < StandardError; end
    class AdapterNotSpecifiedError < StandardError; end
    
    STORES = {}
    
    class << self
      def create_store config
        if config[:adapter].nil?
          raise AdapterNotSpecifiedError, "Unable to determine adapter for data store - adapter not specified!"
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
          raise AdapterNotFoundError, "Unable to find #{adapter} adapter, make sure it is in your load path"
        end
      end
      
    end
  end
end