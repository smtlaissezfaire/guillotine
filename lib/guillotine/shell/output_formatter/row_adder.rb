module Guillotine
  module Shell
    class OutputFormatter
      class RowAdder
        def initialize(column_name, extractor, output_array)
          @column_name = column_name.to_s
          @extractor = extractor
          @out = output_array
        end
        
        def add(last_column)
          @last_column = last_column
          column_name = ColumnOutputer.output(@column_name, column_width, last_column)
          
          @out.add_separator(separator)
          @out.add_column_name(column_name)
          @out.add_values(column_values)
          @out
        end
          
      private
          
        def column_width
          ColumnLengthCalculator.size_of_column(@extractor[:column], @extractor[:values])
        end
        
        def separator
          ColumnDelimiterHeader.output(column_width, @last_column)
        end
        
        def column_values
          @extractor[:values].map do |value|
            ColumnOutputer.output(value, column_width, @last_column)
          end
        end
      end
    end
  end
end
  
