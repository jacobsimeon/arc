require 'arc/data_stores/abstract_data_store'

module Arc
  module DataStores
    extend Q::Dispatcher
    require_pattern "arc/data_stores/%s_data_store"
    constant_suffix "DataStore"
  end
end