require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  
  describe SQLSelectParser do
    before :each do
      @parser = SQLSelectParser.new
    end
    
    def parse(val)
      @parser.parse(val)
    end
    
    describe "number" do
      it "should parse the number 0" do
        parse('0').eval.should == 0
      end
      
      it "should parse the number 1" do
        parse('1').eval.should == 1
      end
      
      it "should parse multiple numbers" do
        parse('123').eval.should == 123
      end
      
      it "should not parse the empty string as a number" do
        lambda { 
          parse('').eval
        }.should raise_error
      end
    end
    
    describe 'string' do
      it "should parse a single char" do
        parse('a').eval.should == "a"
      end
      
      it "should parse multitple chars" do
        parse("aaaa").eval.should == "aaaa"
      end
      
      it "should parse different chars" do
        parse("abcd").eval.should == "abcd"
      end
      
      it "should parse an uppercase char" do
        parse("A").eval.should == "A"
      end
      
      it "should parse a combination of uppercase and lowercase chars" do
        parse("ABcdEF").eval.should == "ABcdEF"
      end
      
      it "should parse underscores" do
        parse("_").eval.should == "_"
      end
    end
  end
end
