
require "rubygems"

project = File.dirname(__FILE__) + "/guillotine"

require "#{project}/require"
require "#{project}/extensions"

Guillotine.module_eval do
  autoload :Assertions,             "#{project}/assertions"
  autoload :DataStore,              "#{project}/data_store"
  autoload :PreParser,              "#{project}/pre_parser"
  autoload :Parser,                 "#{project}/parser"
  autoload :Conditions,             "#{project}/conditions"
  autoload :Keywords,               "#{project}/keywords"
  autoload :Expressions,            "#{project}/expressions"
  autoload :RSpec,                  "#{project}/test_support"
  autoload :RakeTasks,              "#{project}/rake"
  autoload :StatementExecutor,      "#{project}/statement_executor"
  autoload :MultiStatementExecutor, "#{project}/multi_statement_executor"
  autoload :Transactions,           "#{project}/transactions"
  autoload :TestSupport,            "#{project}/test_support"
  autoload :VERSION,                "#{project}/version"
  
  class << self
    def execute(string)
      Guillotine::MultiStatementExecutor.new(string).execute
    end
    
    def parse(string)
      Guillotine::MultiStatementExecutor.new(string).parse
    end
  end
end
