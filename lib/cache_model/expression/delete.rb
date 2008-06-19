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
      
      # TODO: This currently acts just like TRUNCATE TABLE
      # We need to implement the where_clause, the order_by and limit
      def call(collection)
        if limit
          return collection if limit.limit == 0
          collection.slice!(0..limit.limit-1)
          collection
        else
          collection.clear
        end
      end
    end
  end
end
