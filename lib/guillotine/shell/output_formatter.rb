module Guillotine
  module Shell
    class OutputFormatter
      extend Using
      
      using :TableOutputer
      
      EMPTY_SET_STRING = "Empty set"
      
      def self.format(obj)
        new.to_s(obj)
      end
      
      def format(table)
        @table = table
        @table.empty? ? empty_table_output : table_output
      end
      
      def puts(obj)
        Kernel.puts("#{format(obj)}\n\n")
      end
      
      alias_method :to_s, :puts
      
    private
      
      def empty_table_output
        EMPTY_SET_STRING
      end
      
      def table_output
        TableOutputer.new(@table).output
      end
    end
  end
end
