require 'arc/data_stores/data_store'
module Arc
  module DataStores
    STORES = {
      :default => DataStore      
    }
    class << self
      def [](adapter)
        STORES[adapter] || STORES[:default]
      end
    end    
  end  
end