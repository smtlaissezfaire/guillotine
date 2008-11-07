module Guillotine
  module Shell
    class OutputFormatter
      def self.format(obj)
        new.format(obj)
      end
      
      def format(table)
        out = ""
        out << header(table)
        records = table
        records.each do |record|
          out << output_record(record, records)
        end
        out
      end
      
      def puts(obj)
        Kernel.puts format(obj)
      end
      
    private
      
      def spaces(records, column_name, column_value)
        length = max_value_length(records, column_name)
        " " * (length - column_value.to_s.length)
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
