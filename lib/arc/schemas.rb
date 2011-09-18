module Arc
  module Schemas
    extend Q::Dispatcher
    require_pattern "arc/schemas/%s_schema"
    constant_suffix "Schema"
    def self.create_schema config; dispatch config; end
  end
end