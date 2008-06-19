module CachedModel
  module Expression
    class DeleteStatement
      def initialize(table_name, where_clause=nil, order_by=nil, limit=nil)
        @table_name = table_name.to_sym
        @where = where_clause
        @order_by = order_by
        @limit = limit
      end
      
      attr_reader :table_name
      attr_reader :where
      attr_reader :order_by
      attr_reader :limit
      
      def ==(other)
        table_name.equal?(other.table_name) &&
        where == other.where &&
        order_by == other.order_by &&
        limit == other.limit
      end
    end
  end
end
