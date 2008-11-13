module Guillotine
  module Shell
    class OutputFormatter
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
        Kernel.puts("#{format(obj)}\n")
      end
      
      def to_s(obj = nil)
        if obj.nil?
          super
        else
          puts(obj)
        end
      end
      
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
