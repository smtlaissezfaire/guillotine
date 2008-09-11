require 'set'

module Guillotine
  module Expressions
    class From
      def initialize(*table_names)
        @table_names_as_array = table_names
        @table_names = Set.new(table_names.flatten)
      end
      
      attr_reader :table_names
      
      def ==(other)
        other.table_names.subset?(self.table_names) && 
        self.table_names.subset?(other.table_names)
      end
      
      def to_sql
        "FROM #{@table_names_as_array.join(", ")}"
      end
    end
  end
end
