
require File.dirname(__FILE__) + "/../lib/guillotine"

module ParserSpecHelper
  def parse(string)
    @parser.parse(string)
  end
  
  def parse_and_eval(string, *eval_args)
    parse(string).eval(*eval_args)
  end
end

module ActiveRecordSpecHelper
  def setup_database_connection
    database_yml = File.dirname(__FILE__) + "/database.yaml"
    
    ActiveRecord::Base.establish_connection YAML.load(File.open(database_yml))
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Schema.define do  
      create_table :users, :force => true do |t|
        t.column :first_name, :string
        t.column :last_name, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
      end
      
      create_table :test_data, :force => true do |t|
        t.column :a_string, :string
        t.column :a_number, :integer
      end
    end
  end
end

include ActiveRecordSpecHelper
setup_database_connection

class User < ActiveRecord::Base
  guillotine_model
end

class TestData < ActiveRecord::Base
  set_table_name :test_data
end
