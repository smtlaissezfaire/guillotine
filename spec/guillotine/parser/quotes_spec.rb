require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe QuotesParser do
      include ParserSpecHelper

      before :each do
        @parser = QuotesParser.new
      end
      
      def parse_and_eval(string)
        @parser.parse(string)
      end
      
      it "should return an empty array for an empty string" do
        parse_and_eval("").should == ""
      end
      
      it "should return one word in a one word array" do
        parse_and_eval("foo").should == "foo"
      end
      
      it "should return two words" do
        parse_and_eval("foo bar").should == "foo bar"
      end
      
      it "should return two words with spaces with only one space" do
        parse_and_eval("foo  bar").should == "foo bar"
      end
      
      it "should return two words with three spaces with only one space" do
        parse_and_eval("foo   bar").should == "foo bar"
      end
      
      it "should strip spaces between 3 words" do
        parse_and_eval("foo     bar    baz").should == "foo bar baz"
      end
      
      it "should return a single quoted string as it is" do
        parse_and_eval("'foo'").should == "'foo'"
      end
      
      it "should return two words quoted, as is" do
        parse_and_eval("'foo bar'").should == "'foo bar'"
      end
      
      it "should not strip spaces inside single quotes" do
        parse_and_eval("'foo  bar'").should == "'foo  bar'"
      end
      
      it "should strip spaces after quotes" do
        parse_and_eval("'foo    bar' foo    bar").should == "'foo    bar' foo bar"
      end
      
      it "should turn an empty space into an empty array" do
        parse_and_eval(" ").should == ""
      end
      
      it "should turn multiple empty spaces into any empty string" do
        parse_and_eval("         ").should == ""
      end
      
      it "should eval empty double quotes" do
        parse_and_eval("\"\"").should == "\"\""
      end
      
      it "should eval double quotes with text, preserving spacing" do
        parse_and_eval("\"foo   bar\"").should == "\"foo   bar\""
      end
      
      it "should allow single quotes inside double quotes without freaking out" do
        parse_and_eval("\"foo '   fo   bar '   baz\"").should == "\"foo '   fo   bar '   baz\""
      end
      
      it "should not remove spaces inside backticks" do
        parse_and_eval("`foo  bar`").should == "`foo  bar`"
      end
      
      it "should parse with two backticks" do
        parse("``").should_not be_nil
      end
      
      string = "INSERT INTO `users` (`updated_at`, `username`, `created_at`) VALUES('2008-09-29 22:31:32', 'smtlaissezfaire', '2008-09-29 22:31:32')"
      
      it "should parse the string #{string}" do
        parse(string).should_not be_nil
      end
    end
  end
end
