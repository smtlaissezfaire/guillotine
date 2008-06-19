module CachedModel
  module Expression
    class DeleteStatement
      def initialize(table_name, where_clause=nil, order_by=nil, limit=nil)
      end
      
      def ==(other)
        true
      end
    end
  end
end
