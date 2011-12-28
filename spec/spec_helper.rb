#generate a coverage report
require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'rspec'
require 'arc'
require 'arel'
require 'timecop'

module ArcTest
  DEFAULT_ADAPTER = 'sqlite'
  
  class << self
    def env
      @config_key ||= (ENV['ARC_ENV'] ||= ArcTest::DEFAULT_ADAPTER).to_sym
    end
    alias :adapter :env
    def adapter
      env
    end
    
    def get_store
      @store = begin
        s = Arc::DataStores[ArcTest.adapter].new ArcTest.config
        Arel::Table.engine = s
        s.schema.execute_ddl File.read("spec/support/schemas/#{adapter}.sql")
        load "spec/support/seed.rb"
        s
      end
    end
    
    def drop_store store
      store.schema.execute_ddl File.read("spec/support/schemas/drop_#{adapter}.sql")
    end
    
    def _config
      @config ||= YAML::load(File.read "spec/support/config.yml").symbolize_keys!
    end
    
    def config
      _config[env]
    end

  end

end