
require "date"
require "time"
require "treetop"

module Guillotine
  module Parser
    class SQLParseError < StandardError; end

    Expressions      = Guillotine::Expressions       unless defined?(Expressions)
    
    SelectExpression = Expressions::SelectExpression unless defined?(SelectExpression)
    DeleteStatement  = Expressions::DeleteStatement  unless defined?(DeleteStatement)
    Truncate         = Expressions::Truncate         unless defined?(Truncate)
    
    Select           = Expressions::Select           unless defined?(Select)
    From             = Expressions::From             unless defined?(From)
    Limit            = Expressions::Limit            unless defined?(Limit)
    OrderBy          = Expressions::OrderBy          unless defined?(OrderBy)
    OrderByPair      = Expressions::OrderByPair      unless defined?(OrderByPair)
    GroupBy          = Expressions::GroupBy          unless defined?(GroupBy)
    BacktickString   = Expressions::BacktickString   unless defined?(BacktickString)

    Insert           = Expressions::Insert           unless defined?(Insert)
  end
  
  require "gazelle"
  
  require File.dirname(__FILE__) + "/../../ext/quotes_parser/quotes_parser.so"
  extend Using
  
  with_load_scheme :require do
    using :SqlTokens
    using :SqlPrimitives
    using :SqlHelpers
    using :SqlChars
    using :SqlRowSupport
    using :SqlKeyValuePair
    using :SqlWhereCondition
    using :SqlLimit
    using :SqlOrderByClause
    using :SqlGroupByClause
    using :SqlFromClause
    using :SqlSelectClause
    using :SqlSelect
    using :SqlTruncate
    using :SqlDelete
    using :SqlDropTable
    using :SqlShowTables
    using :SqlTransaction
    using :SqlInsert
    using :SqlDatatypes
    # using :SqlCreateTable
    using :Sql
  end

  SQLGazelleParser = Gazelle::Parser.new(File.dirname(__FILE__) + "/parser/create_table")

  module ArrayHelpers
    def car
      first
    end
    
    def cdr
      self[1..self.size]
    end
  end

  ids = []
  ids.extend ArrayHelpers

  SQLGazelleParser.rules do
    on :UNQUOTED_ID do |str|
      ids << str.dup
    end

    on :create_table do |str|
      table_name = ids.car
      columns    = ids.cdr.map { |col| Expressions::Column.new(col) }

      Expressions::CreateTable.new(:table_name => table_name, :columns => columns)
      ids.clear
    end
  end
end
