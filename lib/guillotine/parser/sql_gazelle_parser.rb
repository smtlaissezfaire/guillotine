module Guillotine
  module Parser
    SQLGazelleParser = Gazelle::Parser.new(File.dirname(__FILE__) + "/create_table")

    module ArrayHelpers
      def car
        first
      end
      
      def cdr
        self[1..self.size]
      end
    end

    ids = []
    ids.extend ArrayHelpers

    SQLGazelleParser.rules do
      on :UNQUOTED_ID do |str|
        ids << str.dup
      end

      on :create_table do |str|
        table_name = ids.car
        columns    = ids.cdr.map { |col| Expressions::Column.new(col) }

        Expressions::CreateTable.new(:table_name => table_name, :columns => columns)
        ids.clear
      end
    end
  end
end
