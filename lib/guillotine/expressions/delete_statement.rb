module Guillotine
  module Expressions
    class DeleteStatement < TopLevelExpression
      def initialize(table_name, where_clause=nil, order_by=nil, limit=nil)
        @table_name = table_name.to_sym
        @where = where_clause
        @order_by = order_by
        @limit = limit
      end
      
      attr_reader :table_name
      
      def ==(other)
        table_name.equal?(other.table_name) &&
        where == other.where &&
        order_by == other.order_by &&
        limit == other.limit
      end
      
      def call(collection)
        if !where && !limit
          truncate(collection)
        elsif empty_limit?
          collection
        else
          collection.delete_if { |obj| super.include?(obj) }
        end
      end
      
    private
      
      def truncate(collection)
        truncator.call(collection)
      end
      
      def truncator
        @truncator ||= Truncate.new(table_name)
      end
    end
  end
end
