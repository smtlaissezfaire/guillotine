module Guillotine
  module Shell
    class OutputFormatter
      module ColumnLengthCalculator
        class << self
          def size_of_column(column, values)
            column_length = column_length(column)
            value_length = max_value_length(values)
            
            column_length > value_length ?
              column_length :
              value_length
          end
          
        private
          
          def column_length(column)
            column.to_s.length
          end
          
          def max_value_length(values)
            value_lengths = values.map { |value| value.length }
            value_lengths.sort.last
          end
        end
      end
    end
  end
end

