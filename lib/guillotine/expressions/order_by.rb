module Guillotine
  module Expressions
    class OrderBy
      module SortOptions
        ASC  = :ASC   unless defined? ASC
        DESC = :DESC  unless defined? DESC
        SORT_OPTIONS = [ ASC, DESC ] unless defined?(SORT_OPTIONS)
      end
      
      include SortOptions
      
      def initialize(*columns)
        @pairs = columns.flatten
      end
      
      attr_reader :pairs
      
      def pair
        pairs.size == 1 ? pairs.first : pairs
      end
      
      def ==(other)
        pairs == other.pairs
      end
      
      # TODO: This must be awful in terms of efficiency
      # Fixit when it actually becomes a problem
      def call(collection)
        pairs.reverse.inject(collection) { |collection, pair| pair.call(collection) }
      end
      
      def to_sql
        "ORDER BY #{@pairs.map { |pair| pair.to_sql }.join(", ")}"
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
      
      def call(collection)
        results = collection.sort_by { |x| x[column] }
        desc? ? results.reverse : results
      end
      
      def asc?
        @sort == ASC
      end
      
      def desc?
        !asc?
      end
      
      alias_method :descending?, :desc?
      alias_method :ascending?, :asc?
      
      def to_sql
        "#{column} #{sort}"
      end
    end
  end
end
