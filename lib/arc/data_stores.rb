require 'arc/data_stores/abstract/store'

module Arc
  module DataStores
    extend Q::Dispatcher
    require_pattern "arc/data_stores/%s/store.rb"
    constant_suffix "DataStore"
  end
end