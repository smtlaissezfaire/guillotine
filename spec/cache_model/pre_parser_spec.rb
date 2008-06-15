require File.dirname(__FILE__) + "/../spec_helper"

module CachedModel
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

  end
end
