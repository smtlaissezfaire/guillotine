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
        
        class OutputBuffer
          def initialize
            @separator = ""
            @column_names = ""
            @values = []
          end
          
          def to_s
            out = [
              @separator,
              @column_names,
              @separator,
              @values,
              @separator
            ].join("\n")
            out << "\n"
          end
          
          def add_separator(separator)
            @separator << separator
          end
          
          def add_column_name(column_name)
            @column_names << column_name
          end
          
          def add_values(values)
            @values = if @values.empty?
              values
            else
              @values.zip(values).map { |row| row.join("") }
            end
          end
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
        
        class RowAdder
          def initialize(column_name, extractor, output_array)
            @column_name = column_name.to_s
            @extractor = extractor
            @out = output_array
          end
          
          def add(last_column)
            @last_column = last_column
            column_name = ColumnOutputer.output(@column_name, column_width, last_column)
            
            @out.add_separator(separator)
            @out.add_column_name(column_name)
            @out.add_values(column_values)
            @out
          end
          
        private
          
          def column_width
            ColumnLengthCalculator.size_of_column(@extractor[:column], @extractor[:values])
          end
          
          def separator
            ColumnDelimiterHeader.output(column_width, @last_column)
          end
          
          def column_values
            @extractor[:values].map do |value|
              ColumnOutputer.output(value, column_width, @last_column)
            end
          end
        end
        
        def extractor_for(column_name)
          @extractor = ColumnExtractor.new.extract(column_name, @table)
        end
      end
    end
  end
end
