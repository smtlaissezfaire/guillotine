require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLTruncateParser do
      include ParserSpecHelper

      before :each do
        @parser = SQLTruncateParser.new
      end

      it "should parse TRUNCATE foo" do
        parse("TRUNCATE foo")
      end
      
      it "should parse and eval TRUNCATE foo" do
        parse_and_eval("TRUNCATE foo").should == Expressions::Truncate.new("foo")
      end
      
      it "should parse and eval TRUNCATE bar" do
        parse_and_eval("TRUNCATE bar").should == Expressions::Truncate.new("bar")
      end
      
      it "should not parse and eval two truncate statements with the same table" do
        expr_one = "TRUNCATE bar"
        expr_two = "TRUNCATE foo"
        parse_and_eval(expr_one).should_not == parse_and_eval(expr_two)
        parse_and_eval(expr_two).should_not == parse_and_eval(expr_one)
      end
      
      it "should parse and eval TRUNCATE `bar`" do
        parse_and_eval("TRUNCATE `bar`").should == Expressions::Truncate.new("bar")
      end
      
      it "should parse and eval TRUNCATE     `bar` with spaces" do
        pending <<-HERE do
          FIXME.  See the revision in which this was modified.  
          Most likely, this is a bug with the pre-parser, which doesn't understand
          backtick'ed quotes
        HERE
          parse_and_eval("TRUNCATE       `bar`").should == Expressions::Truncate.new("bar")
        end
      end
      
      it "should parse and eval TRUNCATE TABLE bar" do
        parse_and_eval("TRUNCATE TABLE bar").should == Expressions::Truncate.new("bar")
      end

      it "should parse and eval TRUNCATE TABLE       bar" do
        parse_and_eval("TRUNCATE TABLE        bar").should == Expressions::Truncate.new("bar")
      end
    end
  end
end
