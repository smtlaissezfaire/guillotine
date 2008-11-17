module Guillotine
  module Shell
    class OutputFormatter
      class ColumnOutputer
        def self.output(string, max_size, end_column = false)
          new(string, max_size, end_column).output
        end
        
        class InvalidMaxSizeError < StandardError; end
        
        BAR_SEPARATOR = "|"
        SPACE = " "
        EMPTY_STRING = ""
        
        def initialize(string, max_size, end_column = false)
          @string = string
          @max_size = max_size
          @end_column = end_column
        end
        
        def output
          "#{separator}#{padding}#{@string}#{spaces}#{padding}#{end_separator}"
        end
        
      private
        
        def spaces
          padding * number_of_spaces
        end
        
        def padding
          SPACE
        end
        
        def number_of_spaces
          space_count = @max_size - @string.length
          if space_count < 0
            raise(InvalidMaxSizeError,
                  "The string '#{@string}' cannot fit into a column #{@max_size} chars wide")
          end
          space_count
        end
        
        def end_separator
          @end_column ? separator : EMPTY_STRING
        end
        
        def separator
          BAR_SEPARATOR
        end
      end
    end
  end
end

