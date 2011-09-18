require 'bundler/setup'
require 'rspec'
require 'arc'

module ArcTest
  class << self
    def config_key
      (ENV['ARC_ENV'] ||= 'sqlite').to_sym
    end
    
    def config
      @config ||= read_config.symbolize_keys!
    end
    
    def current_config
      config[config_key]
    end
    
    def adapter
      current_config[:adapter]
    end
    
    def config_file
      File.open "#{File.dirname __FILE__}/support/config.yml"
    end
    
    def read_config
      config = YAML::load config_file
    end
    
    def load_schema
      File.read("#{File.dirname __FILE__}/support/schemas/#{config_key}.sql").split(';').each do |statement|
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
      @store ||= Arc::DataStores[adapter.to_sym].new current_config
    end
    
  end
end

