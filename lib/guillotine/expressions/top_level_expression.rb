module Guillotine
  module Expressions
    class TopLevelExpression
      def call(collection)
        limit!(order!(where!(collection)))
      end
      
      attr_reader :where
      attr_reader :limit
      attr_reader :order_by    

    private
      
      def empty_limit?
        limit && limit.limit == 0
      end
      
      def where!(collection)
        filter_by(where, collection) { where.call(collection) }
      end
      
      def order!(collection)
        filter_by(order_by, collection) { order_by.call(collection) }
      end

      # TODO: Limit should have a call method, just like the rest of
      # the expressions
      def limit!(collection)
        filter_by(limit, collection) { collection.slice(0..limit.limit-1) }
      end
      
      def filter_by(boolean_condition, collection)
        boolean_condition ? yield : collection
      end
    end
  end
end
