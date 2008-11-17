module Guillotine
  module Shell
    class OutputFormatter
      dir = File.dirname(__FILE__) + "/output_formatter"
      
      autoload :ColumnOutputer, "#{dir}/column_outputer"
      autoload :ColumnDelimiterHeader, "#{dir}/column_delimiter_header"
      
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
          empty_table_output
        else
          table_output(table)
        end
      end
      
      def puts(obj)
        Kernel.puts("#{format(obj)}\n\n")
      end
      
      alias_method :to_s, :puts
      
    private
      
      def empty_table_output
        "Empty set"
      end
      
      def table_output(table)
        extractor = ColumnExtractor.new.extract(:column_name, table)
        column_size = ColumnLengthCalculator.size_of_column(extractor[:column], extractor[:values])
        header = ColumnDelimiterHeader.output(column_size, true)
        column_name = ColumnOutputer.output("column_name", column_size, true)
        
        column_values  = extractor[:values].map do |value|
          ColumnOutputer.output(value, column_size, true)
        end.join("\n")
        
<<-HERE
#{header}
#{column_name}
#{header}
#{column_values}
#{header}
HERE
      end
    end
  end
end
