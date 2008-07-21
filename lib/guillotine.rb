
require "rubygems"
require "active_record"

project = File.dirname(__FILE__) + "/guillotine"

require "#{project}/require"
require "#{project}/extensions"
require "#{project}/active_record"

Guillotine.module_eval do
  autoload :Assertions,               "#{project}/assertions"
  autoload :DataStore,       		 			"#{project}/data_store"
  autoload :PreParser,       		 			"#{project}/pre_parser"
  autoload :Parser,                   "#{project}/parser"
  autoload :ConditionNode,   		 			"#{project}/condition_tree"
  autoload :ProperBinaryTree,		 			"#{project}/condition_tree"
  autoload :ConjunctionConditionNode, "#{project}/condition_tree"
  autoload :DisjunctionConditionNode, "#{project}/condition_tree"
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
  
  class Guillotine::TimedCache
    # TODO: use the hash for ttl.  Check options
    def initialize(hash, block)
      @block = block
    end
    
    attr_accessor :block
    
    def cache
      swap { @block.call }
    end
    
    def mysql_adapter
      @mysql_adapter ||= ActiveRecord::ConnectionAdapters::MysqlAdapter
    end
    
    def reset_mysql_adapter!
      @mysql_adapter = nil
    end
    
    attr_writer :mysql_adapter
    
    def row_selector
      @row_selector ||= ::Guillotine::ActiveRecord::RowSelector.new
    end
    
    attr_writer :row_selector
    
  private
    
    def swap
      swap_out_method
      begin
        yield
      ensure
        swap_back_method
      end
    end
    
    def swap_out_method
      row_selector = self.row_selector
      
      mysql_adapter.class_eval do
        alias_method(:__guillotine_select__, :select)

        # TODO: Call the old select when a query can't
        # be parsed
        define_method :select do |sql, name|
          row_selector.select(sql, name)
        end
      end
    end
    
    def swap_back_method
      mysql_adapter.class_eval do
        alias_method(:select, :__guillotine_select__)
        undef :__guillotine_select__
      end
    end
  end
end
