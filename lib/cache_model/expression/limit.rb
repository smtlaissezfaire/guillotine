module Guillotine
  module Expression
    class Limit
      def initialize(number)
        @limit = number
      end
      
      attr_reader :limit
      
      def ==(other)
        other.limit == self.limit
      end
    end
  end
end
