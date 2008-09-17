require File.dirname(__FILE__) + "/../../spec_helper"

require "rubygems"
require "active_record"

module SpecHelpers
  class DatabaseHelper
    def setup_database_connection
      establish_connection
      define_schema
    end
    
    def establish_connection
      ActiveRecord::Base.establish_connection(read_config_file)
    end
    
    def define_schema
      ActiveRecord::Schema.define do  
        create_table :users, :force => true do |t|
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

SpecHelpers::DatabaseHelper.new.setup_database_connection

