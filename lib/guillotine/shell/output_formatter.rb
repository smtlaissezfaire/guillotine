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
          "#{BAR_SEPARATOR}#{SPACE}#{@string}#{spaces}#{SPACE}#{end_column_bar}"
        end
        
        def spaces
          SPACE * number_of_spaces
        end
        
        def number_of_spaces
          space_count = @max_size - @string.length
          if space_count < 0
            raise(InvalidMaxSizeError,
                  "The string '#{@string}' cannot fit into a column #{@max_size} chars wide")
          end
          space_count
        end
        
        def end_column_bar
          @end_column ? BAR_SEPARATOR : EMPTY_STRING
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
        if table.empty?
          "Empty set"
        else
          table_with_data_output(table)
        end
      end
      
      def puts(obj)
        Kernel.puts("#{format(obj)}\n\n")
      end
      
      alias_method :to_s, :puts
      
    private
      
      def table_with_data_output(table)
        out = ""
        out << header(table)
        records = table
        records.each do |record|
          out << output_record(record, records)
        end
        out
      end
      
      def spaces(records, column_name, column_value)
        length_of_values = max_value_length(records, column_name)
        length_of_column = column_value.to_s.length
        number_of_spaces = 
          if length_of_column > length_of_values
            length_of_column - length_of_values
          else
            length_of_values - length_of_column
          end
        
        " " * number_of_spaces
      end
      
      def max_value_length(records, column_name)
        records.map { |record| record[column_name].to_s.length }.max
      end

      # TODO: Refactor later, when less tired
      def header(table)
        str = "| "
        str << column_names(table).map do |column_name|
          "#{column_name}#{spaces(table, column_name, column_name)}"
        end.join(" | ")
        
        "#{str} |\n"
      end
      
      def output_record(record, records)
        out = "| "
        out << record.map do |column_name, value|
          "#{value}#{spaces(records, column_name, value)}"
        end.join(" | ")
        out << " |\n"
      end
      
      def column_names(rows)
        rows.first.keys
      end
    end
  end
end
