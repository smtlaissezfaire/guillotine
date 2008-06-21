module Guillotine
  module Expression
    class From
      def initialize(*table_names)
        @table_names = Set.new(table_names.flatten)
      end
      
      attr_reader :table_names
      
      def ==(other)
        other.table_names.subset?(self.table_names) && 
        self.table_names.subset?(other.table_names)
      end
    end
  end
end
