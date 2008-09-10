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
      
      def call(a_collection)
        return a_collection if a_collection.empty?
        seen_values = []
        
        if columns.size > 1
          GroupBy.new(first_column).call(a_collection) &
          GroupBy.new(*columns[1..columns.size-1]).call(a_collection)
        else
          a_collection.select do |row|
            value = row[first_column_name]
            seen_values << value
            seen_values.select{ |obj| obj == value }.size == 1
          end
        end
      end
      
    private
      
      def first_column
        columns.first
      end
      
      def first_column_name
        first_column.name
      end
    end
  end
end
