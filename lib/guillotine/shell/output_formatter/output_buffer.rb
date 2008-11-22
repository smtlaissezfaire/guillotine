module Guillotine
  module Shell
    class OutputFormatter
      class TableOutputer
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
# Waiting for ordered hashes.  See README
#             @values = if @values.empty?
#               values
#             else
#               @values.zip(values).map { |row| row.join("") }
#             end
            @values = values
          end
        end
      end
    end
  end
end
