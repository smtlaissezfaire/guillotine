module Guillotine
  module Shell
    class OutputFormatter
      class ColumnDelimiterHeader < ColumnOutputer
        PLUS_SEPARATOR = "+"
        DASH = "-"
        CONTENT = DASH
        
        def self.output(column_size, end_column = false)
          new(column_size, end_column).output
        end
        
        def initialize(column_size, end_column = false)
          super(CONTENT * column_size, column_size, end_column)
        end
        
      private
        
        def padding
          DASH
        end
        
        def separator
          PLUS_SEPARATOR
        end
      end
    end
  end
end
