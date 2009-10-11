require "terminal-table"

module Guillotine
  module Shell
    class OutputFormatter
      class TableOutputer
        include Terminal::Table::TableHelper

        def initialize(table)
          @table = table
        end
        
        def column_names
          @column_names ||= @table.first.keys
        end
        
        def output
          table do |t|
            t.headings = column_names

            @table.each do |record|
              t << column_names.map do |col|
                record[col]
              end
            end
          end.to_s
        end
      end
    end
  end
end
