
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
    using :SqlCreateTable
    using :Sql
  end
end
