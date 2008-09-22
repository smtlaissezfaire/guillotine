
require File.dirname(__FILE__) + "/../lib/guillotine"

module ParserSpecHelper
  def parse(string)
    begin
      string = Guillotine::PreParser.parse(string)
    rescue; nil; end
    @parser.parse(string)
  end
  
  def parse_and_eval(string, *eval_args)
    parse(string).eval(*eval_args)
  end
end
