require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  
  describe SQLSelectParser do
    before :each do
      @parser = SQLSelectParser.new
    end
    
    def parse(val)
      @parser.parse(val).eval
    end
    
    describe "number" do
      it "should parse the number 0" do
        parse('0').should == 0
      end
      
      it "should parse the number 1" do
        parse('1').should == 1
      end
      
      it "should parse multiple numbers" do
        parse('123').should == 123
      end
      
      it "should not parse the empty string as a number" do
        lambda { 
          parse('')
        }.should raise_error
      end
    end
    
    describe 'string' do
      it "should parse a single char" do
        parse('a').should == "a"
      end
      
      it "should parse multitple chars" do
        parse("aaaa").should == "aaaa"
      end
      
      it "should parse different chars" do
        parse("abcd").should == "abcd"
      end
      
      it "should parse an uppercase char" do
        parse("A").should == "A"
      end
      
      it "should parse a combination of uppercase and lowercase chars" do
        parse("ABcdEF").should == "ABcdEF"
      end
      
      it "should parse underscores" do
        parse("_").should == "_"
      end
    end
    
    describe "quoted string" do
      it "should use single quotes"
      
      it "should use double quotes"
      
      it "should not parse if it starts with a single quote, but ends in a double quote"
      
      it "should properly nest quotes"
    end
  end
end
