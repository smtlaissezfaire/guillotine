module Guillotine
  module Expressions
    class GroupBy
      def initialize(*columns)
        @columns = columns
      end
      
      attr_reader :columns
      
      def column
        @columns.size > 1 ? @columns : @columns.first
      end
      
      def ==(other)
        @columns == other.columns
      end
    end
  end
end
