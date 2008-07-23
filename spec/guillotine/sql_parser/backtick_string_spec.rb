require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe BacktickString do
      it "should initialize without an error if the first and last chars are backticks" do
        lambda { 
          BacktickString.new("`foo`")
        }.should_not raise_error
      end
      
      it "should raise an error if the last char is not a backtick" do
        lambda { 
          BacktickString.new("`foo")
        }.should raise_error(BacktickString::InvalidString, "The string '`foo' is not a valid backticked string")
      end
      
      it "should raise an error if the first char is not a backtick" do
        lambda { 
          BacktickString.new("foo`")
        }.should raise_error(BacktickString::InvalidString, "The string 'foo`' is not a valid backticked string")
      end
      
      it "should have a value" do
        BacktickString.new("`foo`").value.should == "foo"
      end
      
      it "should have a value (for a different string)" do
        BacktickString.new("`barbaz`").value.should == "barbaz"
      end
    end
  end
end
