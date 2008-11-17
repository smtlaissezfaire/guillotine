module Guillotine
  module Shell
    class OutputFormatter
      class ColumnOutputer
        def self.output(string, max_size, end_column = false)
          new(string, max_size, end_column).output
        end
        
        class InvalidMaxSizeError < StandardError; end
        
        BAR_SEPARATOR = "|"
        SPACE = " "
        EMPTY_STRING = ""
        
        def initialize(string, max_size, end_column = false)
          @string = string
          @max_size = max_size
          @end_column = end_column
        end
        
        def output
          "#{separator}#{padding}#{@string}#{spaces}#{padding}#{end_separator}"
        end
        
      private
        
        def spaces
          padding * number_of_spaces
        end
        
        def padding
          SPACE
        end
        
        def number_of_spaces
          space_count = @max_size - @string.length
          if space_count < 0
            raise(InvalidMaxSizeError,
                  "The string '#{@string}' cannot fit into a column #{@max_size} chars wide")
          end
          space_count
        end
        
        def end_separator
          @end_column ? separator : EMPTY_STRING
        end
        
        def separator
          BAR_SEPARATOR
        end
      end
      
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
      
      class ColumnExtractor
        class UnfoundKeyError < StandardError; end
        
        def extract(column_name, tbl)
          @column_name = column_name
          @table = tbl
          
          check_constraints
          {
            :column => column_name,
            :values => tbl.map { |row| row[column_name].to_s }
          }
        end
        
      private
        
        def check_constraints
          unless @table.first.keys.include?(@column_name)
            raise UnfoundKeyError, "Could not find the key '#{@column_name}'"
          end
        end
      end
      
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
      
      def self.format(obj)
        new.to_s(obj)
      end
      
      def format(table)
        "Empty set"
      end
      
      def puts(obj)
        Kernel.puts("#{format(obj)}\n\n")
      end
      
      alias_method :to_s, :puts
    end
  end
end
