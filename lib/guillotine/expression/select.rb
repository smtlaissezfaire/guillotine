module Guillotine
  module Expression
    class Select
      def initialize(*columns)
        @columns = columns
      end
      
      attr_reader :columns
      
      # TODO: This should be more intelligent
      def ==(other)
        other.columns == self.columns
      end
    end
  end
end
