module Guillotine
  module Shell
    class OutputFormatter
      dir = File.dirname(__FILE__) + "/output_formatter"
      
      autoload :ColumnOutputer,         "#{dir}/column_outputer"
      autoload :ColumnDelimiterHeader,  "#{dir}/column_delimiter_header"
      autoload :ColumnExtractor,        "#{dir}/column_extractor"
      autoload :ColumnLengthCalculator, "#{dir}/column_length_calculator"
      autoload :TableOutputer,          "#{dir}/table_outputer"
      autoload :OutputBuffer,           "#{dir}/output_buffer"
      autoload :RowAdder,               "#{dir}/row_adder"
      
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
      
      def table_output
        TableOutputer.new(@table).output
      end
    end
  end
end
