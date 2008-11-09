
require "rubygems"

project = File.dirname(__FILE__) + "/guillotine"

require "#{project}/require"
require "#{project}/extensions"

Guillotine.module_eval do
  autoload :Assertions,        "#{project}/assertions"
  autoload :DataStore,         "#{project}/data_store"
  autoload :PreParser,         "#{project}/pre_parser"
  autoload :Parser,            "#{project}/parser"
  autoload :Conditions,        "#{project}/conditions"
  autoload :Keywords,          "#{project}/keywords"
  autoload :Expressions,       "#{project}/expressions"
  autoload :RSpec,             "#{project}/test_support"
  autoload :RakeTasks,         "#{project}/rake"
  autoload :StatementExecutor, "#{project}/statement_executor"
  autoload :Transactions,      "#{project}/transactions"
  autoload :TestSupport,       "#{project}/test_support"
  autoload :VERSION,           "#{project}/version"
  
  class << self
    def execute(string)
      statement_executor.execute(string)
    end
    
    def parse(string)
      statement_executor.parse(string)
    end
    
  protected
    
    def statement_executor
      Guillotine::StatementExecutor.new(pre_parser, self.sql_parser)
    end
    
    def sql_parser
      @sql_parser ||= Guillotine::Parser::SQLParser.new
    end
    
  private
    
    def pre_parser
      @pre_parser ||= Guillotine::PreParser
    end
  end
end
