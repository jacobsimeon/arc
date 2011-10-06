require 'bundler/setup'
require 'rspec'
require 'arc'
require 'q/resource_pool'

module ArcTest
  class StoreProvider < ResourcePool
    def create_resource
      Arc::DataStores[ArcTest.adapter].new ArcTest.current_config    
    end
  end  
  
  class << self
    def config_key
      @config_key ||= (ENV['ARC_ENV'] ||= 'sqlite').to_sym
    end
    
    def config
      @config ||= YAML::load(File.read "#{File.dirname __FILE__}/support/config.yml").symbolize_keys!
    end
    
    def with_store
      file_root = "#{File.dirname __FILE__}/support/schemas"
      ddl = File.read "#{file_root}/#{config_key}.sql"
      drop_ddl = File.read "#{file_root}/drop_#{config_key}.sql"
      provider.with_resource do |store|
        #store.schema.drop_schema
        store.schema.execute_ddl ddl
        yield store
        store.schema.execute_ddl drop_ddl
      end
    end
    
    def current_config
      @count ||= 0
      db_name = "#{config[config_key][:database]}-#{@count}"
      @count += 1
      config[config_key].merge({ database: db_name })
    end
    
    def adapter
      current_config[:adapter].to_sym
    end
    
    private
    def provider
      @provider ||= StoreProvider.new nil
    end    
  end
  
end