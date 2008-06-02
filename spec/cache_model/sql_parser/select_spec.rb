require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  
  describe SQLSelectParser do
    before :each do
      @parser = SQLSelectParser.new
    end
    
    def parse(string)
      @parser.parse(string)
    end
    
    def parse_and_eval(string, *eval_args)
      parse(string).eval(*eval_args)
    end
    
    describe "number" do
      it "should parse the number 0" do
        parse_and_eval('0').should == 0
      end
      
      it "should parse the number 1" do
        parse_and_eval('1').should == 1
      end
      
      it "should parse multiple numbers" do
        parse_and_eval('123').should == 123
      end
      
      it "should not parse the empty string as a number" do
        lambda { 
          parse_and_eval('')
        }.should raise_error
      end
    end
    
    describe 'string' do
      it "should parse a single char" do
        parse_and_eval('a').should == "a"
      end
      
      it "should parse multitple chars" do
        parse_and_eval("aaaa").should == "aaaa"
      end
      
      it "should parse different chars" do
        parse_and_eval("abcd").should == "abcd"
      end
      
      it "should parse an uppercase char" do
        parse_and_eval("A").should == "A"
      end
      
      it "should parse a combination of uppercase and lowercase chars" do
        parse_and_eval("ABcdEF").should == "ABcdEF"
      end
      
      it "should parse underscores" do
        parse_and_eval("_").should == "_"
      end
    end
    
    describe "backtick string" do
      before(:each) do
        @backtick_string = mock("BacktickString")
        @backtick_class = mock('BacktickStringClass', :new => @backtick_string)
      end
      
      it "should parse a simple string properly" do
        @backtick_class.should_receive(:new).with("`foo`").and_return @backtick_string
        parse_and_eval("`foo`", @backtick_class)
      end
      
      it "should parse a different string properly" do
        @backtick_class.should_receive(:new).with("`foobar`").and_return @backtick_string
        parse_and_eval("`foobar`", @backtick_class).should == @backtick_string
      end
    end
    
    describe "quoted string" do
      it "should use single quotes" do
        parse_and_eval("'foo'").should == "foo"
      end
      
      it "should use double quotes" do
        parse_and_eval("\"foo\"").should == "foo"
      end
      
      it "should not parse if it starts with a single quote, but ends in a double quote" do
        parse("\"foo'").should be_nil
      end
      
      it "should not parse if it starts with a double quote and ends in a single quote" do
        parse("'foo\"").should be_nil
      end
      
      it "should not parse a string which has three double quotes" do
        parse('"foo"bar"').should be_nil
      end
      
      it "should match the empty string with single quotes" do
        parse_and_eval("''").should == ""
      end
      
      it "should match the empty string with double quotes" do
        parse_and_eval('""').should == ""
      end
      
      it "should properly nest single quotes" do
        parse_and_eval("\"foo'bar\"").should == "foo'bar"
      end
      
      it "should properly nest a single double quotes" do
        parse_and_eval("'foo\"bar'").should == "foo\"bar"
      end
      
      it "should properly nest two single double quotes" do
        parse_and_eval("'foo\"bar\"'").should == "foo\"bar\""
      end
    end
    
    describe "condition" do
      describe "with '='" do
        it "should parse foo='bar'
      end
    end
    
    describe "condition clause"
  end
end
