module Guillotine
  class StatementExecutor
    def initialize(pre_parser, parser)
      @pre_parser = pre_parser
      @parser = parser
    end
    
    attr_reader :parser, :pre_parser
    
    def execute(string)
      parse_and_eval(pre_process(string))
    end
    
  private
    
    def parse_and_eval(string)
      parse(string).eval
    end
    
    def parse(string)
      parser.parse(string)
    end
    
    def pre_process(string)
      pre_parser.parse(string)
    end
  end
end
