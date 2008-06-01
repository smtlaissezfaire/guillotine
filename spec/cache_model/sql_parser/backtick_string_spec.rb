require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  describe BackTickString do
    it "should initialize without an error if the first and last chars are backticks" do
      lambda { 
        BackTickString.new("`foo`")
      }.should_not raise_error
    end
    
    it "should raise an error if the last char is not a backtick" do
      lambda { 
        BackTickString.new("`foo")
      }.should raise_error(BackTickString::InvalidString, "The string '`foo' is not a valid backticked string")
    end
    
    it "should raise an error if the first char is not a backtick" do
      lambda { 
        BackTickString.new("foo`")
      }.should raise_error(BackTickString::InvalidString, "The string 'foo`' is not a valid backticked string")
    end
    
    it "should have a value" do
      BackTickString.new("`foo`").value.should == "foo"
    end
    
    it "should have a value (for a different string)" do
      BackTickString.new("`barbaz`").value.should == "barbaz"
    end
  end
end
