require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe QuotesParser do
      include ParserSpecHelper

      before :each do
        @parser = QuotesParser.new
      end
      
      it "should return an empty array for an empty string" do
        parse_and_eval("").should == []
      end
      
      it "should return one word in a one word array" do
        parse_and_eval("foo").should == ["foo"]
      end
      
      it "should return two words in a two word array" do
        parse_and_eval("foo bar").should == ["foo", "bar"]
      end
      
      it "should return three words in a three word array" do
        parse_and_eval("foo bar baz").should == ["foo", "bar", "baz"]
      end
      
      it "should return two words with spaces in a two word array" do
        parse_and_eval("foo   bar").should == ["foo", "bar"]
      end
      
      it "should return a single quoted string in a one word array, still quoted" do
        parse_and_eval("'foo'").should == ["'foo'"]
      end
      
      it "should return two words, in single quotes, in a one word array" do
        parse_and_eval("'foo bar'").should == ["'foo bar'"]
      end
      
      it "should return the correct two words" do
        parse_and_eval("'bar foo'").should == ["'bar foo'"]
      end
      
      it "should return two words quoted with a single quote with spaces, unmodified, as one word" do
        string = "'bar    foo'"
        parse_and_eval(string).should == [string]
      end
      
      it "should split two single quoted words" do
        parse("'foo''bar'").should_not be_nil
        parse_and_eval("'foo''bar'").should == ["'foo'", "'bar'"]
      end
      
      it "should split two single quoted words with a space between them" do
        pending 'todo'
        parse("'foo' 'bar'").should_not be_nil
        parse_and_eval("'foo' 'bar'").should == ["'foo'", "'bar'"]
      end
      
      
      it "should allow uppercase words" do
        parse_and_eval("FOO").should == ["FOO"]
      end
      
      it "should allow numbers" do
        parse_and_eval("7").should == ["7"]
      end
      
      ["%", "&", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "_", "|", "[", "]"].each do |sym|
        it "should allow the symbol #{sym}" do
          parse_and_eval(sym).should == [sym]
        end
      end
      
      it "should turn an empty space into an empty array" do
        parse_and_eval(" ").should == []
      end
      
      it "should turn multiple empty spaces into any empty array" do
        parse_and_eval("         ").should == []
      end
      
      it "should eval empty double quotes" do
        parse_and_eval("\"\"").should == ["\"\""]
      end
      
      it "should eval double quotes with text, preserving spacing" do
        parse_and_eval("\"foo   bar\"").should == ["\"foo   bar\""]
      end
      
      it "should eval double quotes with text in front of the quotes" do
        parse_and_eval("foo  \"foo   bar\"").should == ["foo", "\"foo   bar\""]        
      end
      
      it "should parse single quote escaping" do
        pending 'todo'
        parse_and_eval("'foo\\'bar'").should == ["\'foo\\\'bar\'"]
      end
      
      it "should allow double escaping of single quotes" do
        pending 'todo'
        parse_and_eval("'foo \'bar\''").should == ["foo 'bar'"]
      end
      
      it "should allow escaping of a double quote inside a double quote region" do
        string = '"\""'
        parse(string).should_not be_nil
        parse_and_eval(string).should == ['"\""']
      end
      
      it "should allow escaping of a double quote inside a double quote region, which has text" do
        string = '"foo \" bar"'
        parse(string).should_not be_nil
        parse_and_eval(string).should == [string]
      end
      
      it "should return a quoted word with an unquoted word as two seperate words" do
        string = "'foo'bar"
        parse_and_eval(string).should == ["'foo'", "bar"]
      end
    end
  end
end
