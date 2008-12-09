module Guillotine
  module StatementExecutors
    class MultiExecutor
      class << self
        DEFAULT_DELIMITER = ";"
        
        attr_writer :delimiter
        
        def delimiter
          @delimiter ||= DEFAULT_DELIMITER
        end
        
        def reset_delimiter!
          @delimiter = nil
        end
      end
      
      def initialize(string)
        @string = string
        @delimiter = self.class.delimiter
      end
      
      attr_reader :string
      attr_writer :executor
      attr_reader :delimiter
      
      def executor
        @executor ||= Guillotine::StatementExecutor.new
      end
      
      def parse
        execute_and_return_statement do |statement|
          executor.parse(statement)
        end
      end
      
      def execute
        execute_and_return_statement do |statement|
          executor.execute(statement)
        end
      end
      
      def statements
        @string.split(delimiter)
      end
      
    private
      
      def execute_and_return_statement
        results = statements.map do |statement|
          yield(statement)
        end
        first_or_array(results)
      end
      
      def first_or_array(array)
        array.size > 1 ? array : array.first
      end
    end
  end
end
