require "rubygems"
require "spec"
require File.dirname(__FILE__) + "/../lib/guillotine"

module ParserSpecHelper
  def pre_parse(string)
    Guillotine::PreParser.parse(string)
  end
  
  def parse(string)
    if pre_parsed_string = pre_parse(string)
      @parser.parse(pre_parsed_string)
    else
      raise "* Could not pre-parse string! '#{string}'"
    end
  end
  
  def parse_and_eval(string, *eval_args)
    parse(string).eval(*eval_args)
  end
end

module TestUnitRemover
  def self.remove!
    require "active_record"

    if defined?(Test)
      Object.instance_eval do
        remove_const(:Test)
      end
    end
  end
end

Spec::Runner.configure do |conf|
  conf.before(:each) do
    Guillotine::DataStore.__clear_all_tables!
  end
end

TestUnitRemover.remove!
