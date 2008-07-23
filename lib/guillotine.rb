
require "rubygems"

project = File.dirname(__FILE__) + "/guillotine"

require "#{project}/require"
require "#{project}/extensions"

Guillotine.module_eval do
  autoload :Assertions,      		 			"#{project}/assertions"
  autoload :DataStore,       		 			"#{project}/data_store"
  autoload :PreParser,       		 			"#{project}/pre_parser"
  autoload :Parser,                   "#{project}/parser"
  autoload :Conditions,               "#{project}/conditions"
  autoload :Keywords,         				"#{project}/keywords"
  autoload :Expression,       				"#{project}/expression"
  autoload :RakeTasks,        				"#{project}/rake"
  autoload :StatementExecutor,        "#{project}/statement_executor"
  autoload :Transactions,             "#{project}/transactions"
  
  class << self
    def execute(string)
      Guillotine::StatementExecutor.new(pre_parser, self.sql_parser).execute(string)
    end
    
  protected
    
    def sql_parser
      @sql_parser ||= Guillotine::Parser::SQLParser.new
    end
    
  private
    
    def pre_parser
      @pre_parser ||= Guillotine::PreParser
    end
  end
end
