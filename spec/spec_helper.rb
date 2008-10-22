
require "rubygems"
require "spec"
require File.dirname(__FILE__) + "/../lib/guillotine"

module ParserSpecHelper
  def pre_parse(string)
    Guillotine::PreParser.parse(string)
  end
  
  def parse(string)
    @parser.parse(pre_parse(string))
  end
  
  def parse_and_eval(string, *eval_args)
    parse(string).eval(*eval_args)
  end
end
