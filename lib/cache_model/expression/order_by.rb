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
        @columns = columns.flatten
      end
      
      attr_reader :columns
      
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
    end
  end
end
