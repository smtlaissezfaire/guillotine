module Guillotine
  module Expressions
    class Limit
      def initialize(number)
        @limit = number
      end
      
      attr_reader :limit
      
      def ==(other)
        other.limit == self.limit
      end
      
      def to_sql
        "LIMIT #{@limit}"
      end
    end
  end
end
