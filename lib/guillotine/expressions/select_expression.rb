module Guillotine
  module Expressions
    class SelectExpression < Expressions::TopLevelExpression
      include Assertions
      
      def initialize(hash)
        @select = hash[:select]
        @from = hash[:from]
        @where = hash[:where]
        @limit = hash[:limit]
        @order_by = hash[:order_by]
        @query_string = hash[:string]
      end

      attr_reader :select
      attr_reader :from
      attr_reader :query_string
      
      def inspect
        "#{self.class}: #{query_string}"
      end

      def ==(other)
        assert_each_expression do
          assert_equal self.select,   other.select
          assert_equal self.where,    other.where
          assert_equal self.from,     other.from
          assert_equal self.limit,    other.limit
          assert_equal self.order_by, other.order_by
        end
      end
      
      def call(collection = nil)
        if collection
          (empty_limit? || collection.empty?) ? [] : super
        else
          call_with_collection(from.table)
        end
      end
      
      alias_method :call_with_collection, :call
      
      def to_sql
        string = "#{@select.to_sql} #{@from.to_sql}"
        string += "\n#{@where.to_sql}"    if @where
        string += "\n#{@order_by.to_sql}" if @order_by
        string += "\n#{@limit.to_sql}"    if @limit
        string
      end
      
      # TODO: In the future, eql? and == should not be the
      # same in all cases.  For now, they are aliased, but
      # in the future eql? should be the case in which two queries
      # are parsed in *exactly* the same way, where == should be
      # looser in meaning; The following queries should be ==, but not eql?:
      #
      # SELECT * FROM events WHERE foo = "Scott"
      # SELECT * FROM `events` WHERE foo = 'Scott'
      alias_method :eql?, :==
    end
  end
end
