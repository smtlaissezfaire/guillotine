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
      
      # TODO: This currently acts just like TRUNCATE TABLE
      # We need to implement the where_clause, the order_by and limit
      def call(collection)
        return truncate(collection) if !where && !limit
        return collection if limit && limit.limit == 0
        
        if where
          to_delete = where.call(collection)
        else
          to_delete = collection
        end
        
        if order_by
          to_delete = order_by.call(to_delete)
        end
        
        if limit
          to_delete = to_delete.slice(0..limit.limit-1)
        end
        
        collection.delete_if { |obj| to_delete.include?(obj) }
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
