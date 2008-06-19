module CachedModel
  module Expression
    class OrderBy
      module SortOptions
        SORT_OPTIONS = [
          DESC = :DESC,
          ASC  = :ASC
        ] unless defined?(SORT_OPTIONS)
      end
      
      include SortOptions
      
      def initialize(*columns)
        @pairs = columns
        # TODO: Remove this
        @columns = columns.flatten
      end
      
      # TODO: remove this
      attr_reader :pairs
      
      def pair
        pairs.size == 1 ? pairs.first : pairs
      end
      
      attr_reader :columns
      
      # TODO: fix this implementation
      def ==(other)
        other.columns == self.columns
      end
    end
    
    class OrderByPair
      include OrderBy::SortOptions
      
      def initialize(column, sort = ASC)
        @column = column.to_sym
        @sort = sort
      end
      
      attr_reader :column
      attr_reader :sort
      
      def ==(other)
        return false if !other.kind_of?(self.class)
        self.column.equal?(other.column) && self.sort == other.sort
      end
    end
  end
end
