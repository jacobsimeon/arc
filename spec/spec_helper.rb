require 'bundler/setup'
require 'rspec'
require 'aruba'
require 'arc'


ENV['ARC_ENV'] ||= 'sqlite'
module ArcTest
  class << self
    
    def config
      @config ||= read_config.symbolize_keys!
    end
    
    def config_file
      File.open "#{File.dirname __FILE__}/support/config.yml"
    end
    
    def read_config
      config = YAML::load config_file
    end
    
    def load_schema
      File.read("#{File.dirname __FILE__}/support/schemas/#{ENV['ARC_ENV']}.sql").split(';').each do |statement|
        store.send :execute, statement
      end
    end
    
    def drop_schema    
      if config[ENV['ARC_ENV'].to_sym][:adapter] == 'sqlite'
        File.delete config[ENV['ARC_ENV'].to_sym][:database] and return
      end
      drop_file = "#{File.dirname __FILE__}/support/schemas/drop_#{ENV['ARC_ENV']}.sql"
      if File.exists? drop_file
        store.send :execute, File.read(drop_file)
      end
    end
    
    def store
      @store ||= Arc::DataStores.create_store config[ENV['ARC_ENV'].to_sym]
    end
    
  end
end