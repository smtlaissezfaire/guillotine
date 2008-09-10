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
        @columns.size > 1 ?
          multi_group(columns, a_collection) :
          single_group(columns.first, a_collection)
      end
      
    private
      
      def multi_group(columns, a_collection)
        first = columns.first
        rest = columns[1..columns.size-1]
        
        single_group(first, a_collection) &
        GroupBy.new(*rest).call(a_collection)
      end
      
      def single_group(a_column, a_collection)
        if a_collection.empty?
          a_collection
        else
          seen_values = []
          
          a_collection.select do |row|
            value = row[a_column.name]
            seen_values << value
            seen_values.select{ |obj| obj == value }.size == 1
          end
        end
      end
    end
  end
end
