require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe PreParser do
    before :each do
      @pre_parser = PreParser.new
    end
    
    def parse(string)
      @pre_parser.parse(string)
    end
    
    it "should remove any spaces at the start of the string" do
      parse("   foo").should == "foo"
    end
    
    it "should remove any spaces at the end of the string" do
      parse("foo     ").should == "foo"
    end
    
    it "should remove any carriage returns" do
      parse("foo\r\rbar\r\rbaz").should == "foobarbaz"
    end
    
    it "should replace \n's with spaces" do
      parse("foo\nbar\nbaz").should == "foo bar baz"
    end
    
    it "should not have \n's at the start of a line" do
      parse("\n\nfoo\nbar\nbaz").should == "foo bar baz"      
    end
    
    it "should not have \n's at the end of a line" do
      parse("\n\nfoo\nbar\nbaz").should == "foo bar baz"      
    end
    
    it "should collapse multiple \n's into one space" do
      parse("foo\n\n\nbar").should == "foo bar"
    end
    
    describe "parse, the class method" do
      before :each do
        @parser = mock 'pre-parser', :parse => "results"
        PreParser.stub!(:new).and_return @parser
      end
      
      it "should create a new pre_parser" do
        PreParser.should_receive(:new).and_return @parser
        PreParser.parse('a string')
      end
      
      it "should call parse on the instance with the string given" do
        @parser.should_receive(:parse).with('a string').and_return "results"
        PreParser.parse('a string')
      end
    end
    
    it "should replace two spaces with one" do
      parse("foo  bar").should == "foo bar"
    end
    
    it "should replace three spaces with one" do
      parse("foo   bar").should == "foo bar"
    end
    
    it "should not change the spaces inside a single quote" do
      parse("'foo  bar'").should == "'foo  bar'"
    end
    
#       describe "quoted string" do
#         it "should use single quotes" do
#           parse_and_eval("'foo'").should == "foo"
#         end
        
#         it "should use double quotes" do
#           parse_and_eval("\"foo\"").should == "foo"
#         end
        
#         it "should not parse if it starts with a single quote, but ends in a double quote" do
#           parse("\"foo'").should be_nil
#         end
        
#         it "should not parse if it starts with a double quote and ends in a single quote" do
#           parse("'foo\"").should be_nil
#         end
        
#         it "should not parse a string which has three double quotes" do
#           parse('"foo"bar"').should be_nil
#         end
        
#         it "should match the empty string with single quotes" do
#           parse_and_eval("''").should == ""
#         end
        
#         it "should match the empty string with double quotes" do
#           parse_and_eval('""').should == ""
#         end
        
#         it "should properly nest single quotes" do
#           parse_and_eval("\"foo'bar\"").should == "foo'bar"
#         end
        
#         it "should properly nest a single double quotes" do
#           parse_and_eval("'foo\"bar'").should == "foo\"bar"
#         end
        
#         it "should properly nest two single double quotes" do
#           parse_and_eval("'foo\"bar\"'").should == "foo\"bar\""
#         end
#       end

#           describe "backtick string" do
#         before(:each) do
#           @backtick_string = mock("BacktickString")
#           @backtick_class = mock('BacktickStringClass', :new => @backtick_string)
#         end
        
#         it "should parse a simple string properly" do
#           @backtick_class.should_receive(:new).with("`foo`").and_return @backtick_string
#           parse_and_eval("`foo`", @backtick_class)
#         end
        
#         it "should parse a different string properly" do
#           @backtick_class.should_receive(:new).with("`foobar`").and_return @backtick_string
#           parse_and_eval("`foobar`", @backtick_class).should == @backtick_string
#         end
#       end
      

    
  end
end
