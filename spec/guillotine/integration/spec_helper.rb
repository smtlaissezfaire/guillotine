require File.dirname(__FILE__) + "/../../spec_helper"

require "active_record"

module SpecHelpers
  class DatabaseHelper
    def self.setup_connection
      @obj ||= new
      @obj.setup_connection unless @obj.already_connected?
    end

    def initialize
      @setup_connection = false
    end

    def setup_connection
      establish_connection
      define_schema
      @setup_connection = true
    end

    def setup_connection?
      @setup_connection
    end

    alias_method :already_connected?, :setup_connection?
    
    def establish_connection
      ActiveRecord::Base.establish_connection(read_config_file)
    end
    
    def define_schema
      ActiveRecord::Schema.define do  
        create_table :users, :force => true do |t|
          t.string :username
          t.timestamps
        end
      end
    end
    
  private
    
    def read_config_file
      YAML.load(File.read(config_file_path))["guillotine_test"]
    end
    
    def config_file_path
      File.dirname(__FILE__) + "/database.yml"
    end
  end
end

SpecHelpers::DatabaseHelper.setup_connection