require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  
  describe SQLSelectParser do
    before :each do
      @parser = SQLSelectParser.new
    end
    
    describe "number" do
      it "should parse the number 0" do
        @parser.parse('0').eval.should == 0
      end
      
      it "should parse the number 1" do
        @parser.parse('1').eval.should == 1
      end
      
      it "should parse multiple numbers" do
        @parser.parse('123').eval.should == 123
      end
      
      it "should not parse the empty string as a number" do
        lambda { 
          @parser.parse('').eval
        }.should raise_error
      end
    end
    
    describe 'string' do
      it "should be a single char"
      
      it "should be multitple chars"
    end
  end
end
