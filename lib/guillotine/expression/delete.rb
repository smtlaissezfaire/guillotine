module Guillotine
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
      
      def call(collection)
        return truncate(collection) if !where && !limit
        return collection if limit && limit.limit == 0

        to_delete = limit!(order!(where!(collection)))
        collection.delete_if { |obj| to_delete.include?(obj) }
       end
      
    private
      
      def where!(collection)
        filter_by(where, collection) { where.call(collection) }
      end
      
      def order!(collection)
        filter_by(order_by, collection) { order_by.call(collection) }
      end
      
      def limit!(collection)
        filter_by(limit, collection) { collection.slice(0..limit.limit-1) }
      end
      
      def filter_by(boolean_condition, collection)
        boolean_condition ? yield : collection
      end
      
      def truncate(collection)
        truncator.call(collection)
      end
      
      def truncator
        @truncator ||= Truncate.new(table_name)
      end
    end
  end
end
