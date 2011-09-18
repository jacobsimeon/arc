module Arc
  module DataStores
    extend Q::Dispatcher
    require_pattern "arc/data_stores/%s_data_store"
    constant_suffix "DataStore"
    def self.create_store config; dispatch config; end
  end
end