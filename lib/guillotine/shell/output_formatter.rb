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
      
      def extractor_for(column_name)
        @extractor = ColumnExtractor.new.extract(column_name, @table)
      end
      
      def size_of_column
        ColumnLengthCalculator.size_of_column(@extractor[:column], @extractor[:values])
      end
      
      def separator
        ColumnDelimiterHeader.output(size_of_column, @last_column)
      end
      
      def column_values
        @extractor[:values].map do |value|
          ColumnOutputer.output(value, size_of_column, @last_column)
        end
      end
      
      def table_output
        column_names = @table.first.keys
        out_buffer = ["", "", "", [], ""]
        
        last_column_name = column_names.last
        column_names.each do |column_name|
          column_output(column_name, out_buffer, column_name.equal?(last_column_name))
        end
        out_buffer.join("\n") + "\n"
      end
      
      def column_output(column_name, out, last_column)
        @last_column = last_column
        extractor = extractor_for(column_name)
        column_size = size_of_column
        header = separator
        column_name = ColumnOutputer.output(column_name.to_s, column_size, last_column)
        
        out[0] << separator
        out[1] << column_name
        out[2] << separator
        if out[3].empty?
          out[3] = column_values
        else
          out[3] = out[3].zip(column_values).map { |row| row.join("") }
        end
        out[4] << separator
        out
      end
    end
  end
end
