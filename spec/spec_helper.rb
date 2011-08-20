require 'bundler/setup'
require 'rspec'
require 'aruba'
require 'arc'

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
    
  end
end