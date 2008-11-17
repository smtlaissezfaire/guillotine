module Guillotine
  module Shell
    class OutputFormatter
      dir = File.dirname(__FILE__) + "/output_formatter"
      
      autoload :ColumnOutputer, "#{dir}/column_outputer"
      autoload :ColumnDelimiterHeader, "#{dir}/column_delimiter_header"
      autoload :ColumnExtractor, "#{dir}/column_extractor"
      autoload :ColumnLengthCalculator, "#{dir}/column_length_calculator"
      
      def self.format(obj)
        new.to_s(obj)
      end
      
      def format(table)
        @table = table
        
        if table.empty?
          empty_table_output
        else
          table_output
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
      
      def extractor_for(column)
        @extractor = ColumnExtractor.new.extract(:column_name, @table)
      end
      
      def size_of_column
        ColumnLengthCalculator.size_of_column(@extractor[:column], @extractor[:values])
      end
      
      def separator
        ColumnDelimiterHeader.output(size_of_column, true)
      end
      
      def column_values
        @extractor[:values].map do |value|
          ColumnOutputer.output(value, size_of_column, true)
        end.join("\n")
      end
      
      def table_output
        extractor = extractor_for(:column_name)
        column_size = size_of_column
        header = separator
        column_name = ColumnOutputer.output("column_name", column_size, true)
<<-HERE
#{separator}
#{column_name}
#{separator}
#{column_values}
#{separator}
HERE
      end
    end
  end
end
