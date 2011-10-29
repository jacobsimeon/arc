#generate a coverage report
require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'rspec'
require 'arc'
require 'arel'
require 'q/resource_pool'


RSpec.configure do |config|
  config.after(:all) do
    ArcTest.drop
  end
end

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
    
    def file_root
      @file_root  ||= "#{File.dirname __FILE__}/support/schemas"      
    end    
    
    def config
      @config ||= YAML::load(File.read "#{File.dirname __FILE__}/support/config.yml").symbolize_keys!
    end
    
    def drop
      return unless @schema_loaded
      @drop_ddl ||= File.read "#{file_root}/drop_#{config_key}.sql"
      provider.with_resource { |store| store.schema.execute_ddl @drop_ddl }
      @schema_loaded = false
    end
    
    def load_schema
      return if @schema_loaded
      @ddl ||= File.read "#{file_root}/#{config_key}.sql"
      provider.with_resource { |store| store.schema.execute_ddl @ddl }
      @schema_loaded = true
    end
    
    def reset_schema
      drop
      load_schema
    end      
    
    def with_store
      reset_schema
      provider.with_resource do |store|
        yield store
      end
    end
    
    def current_config
      config[config_key]
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