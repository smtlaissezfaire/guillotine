module Guillotine
  module Expressions
    class Select
      def initialize(*columns)
        @columns = columns
      end
      
      attr_reader :columns
      
      # TODO: This should be more intelligent
      def ==(other)
        other.columns == self.columns
      end
      
      def to_sql
        "SELECT #{@columns.map { |column| column.to_sql }.join(", ")}"
      end
    end
  end
end
