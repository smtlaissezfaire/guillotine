module SpecHelperFunctions
  def setup_database_connection
    require 'rubygems'
    require 'sqlite3'
    require 'active_record'
    require 'active_support'
    
    ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database  => ':memory:'
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Schema.define do  
      create_table :people do |t|
        t.string :first_name
        t.string :last_name
        t.string :phone_number
      end
    end
  end
end

include SpecHelperFunctions
setup_database_connection

class Person < ActiveRecord::Base
end

