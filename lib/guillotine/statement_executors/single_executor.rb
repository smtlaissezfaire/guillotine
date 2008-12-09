module Guillotine
  module StatementExecutors
    class SQLParseError < StandardError; end
    
    class SingleExecutor
      def initialize(pre_parser = Guillotine::PreParser, parser = Guillotine::Parser::SQLParser.new)
        @pre_parser = pre_parser
        @parser = parser
      end
      
      attr_reader :parser, :pre_parser
      
      def parse(string)
        parse_and_eval(pre_process(string))
      end
      
      def execute(string)
        parse(string).call
      end
      
    private
      
      def parse_and_eval(string)
        parse_sql(string).eval
      end
      
      def parse_sql(string)
        result = parser.parse(string)
        if result
          result
        else
          raise(Guillotine::Parser::SQLParseError, "Could not parse query: #{string}")
        end
      end
      
      def pre_process(string)
        pre_parser.parse(string)
      end
    end
  end
end
