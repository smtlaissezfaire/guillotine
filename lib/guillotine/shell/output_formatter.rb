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
