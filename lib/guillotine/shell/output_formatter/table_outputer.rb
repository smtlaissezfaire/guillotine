module Guillotine
  module Shell
    class OutputFormatter
      class TableOutputer
        def initialize(table)
          @table = table
          @out_buffer = OutputBuffer.new
        end
        
        def column_names
          @column_names ||= @table.first.keys
        end
        
        def output
          last_column_name = column_names.last
          column_names.each do |column_name|
            add_column(column_name)
          end
          @out_buffer.to_s
        end
        
        def last_column_name
          @last_column_name ||= column_names.last
        end
        
        def last_column?(column_name)
          last_column_name == column_name
        end
        
        def add_column(column_name)
          RowAdder.new(column_name, extractor_for(column_name), @out_buffer).add(last_column?(column_name))
        end
        
        def extractor_for(column_name)
          @extractor = ColumnExtractor.new.extract(column_name, @table)
        end
      end
    end
  end
end
