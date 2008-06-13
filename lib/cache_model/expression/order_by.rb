module CachedModel
  module Expression
    class OrderBy
      def initialize(*columns)
        @columns = columns.flatten
      end
      
      attr_reader :columns
      
      def ==(other)
        other.columns == self.columns
      end
    end
  end
end
