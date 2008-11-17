require File.dirname(__FILE__) + "/../../../spec_helper"

module Guillotine
  module Shell
    describe OutputFormatter::ColumnOutputer do
      before(:each) do
        @outputer = OutputFormatter::ColumnOutputer
      end
      
      it "should output a string with 'foo' with a max size of 7" do
        @outputer.output("foo", 7).should == "| foo |"
      end
      
      it "should output the correct string" do
        @outputer.output("bar", 7).should == "| bar |"
      end
      
      it "should add one extra space" do
        @outputer.output("bar", 8).should == "| bar  |"
      end
      
      it "should add two extra spaces" do
        @outputer.output("foo", 9).should == "| foo   |"
      end
      
      it "should raise an error if there is not enough space" do
        lambda {
          @outputer.output("foo", 6)
        }.should raise_error(OutputFormatter::ColumnOutputer::InvalidMaxSizeError, "The string 'foo' cannot fit into a column 6 chars wide")
      end
      
      it "should raise an error with the correct column name" do
        lambda {
          @outputer.output("bar", 6)
        }.should raise_error(OutputFormatter::ColumnOutputer::InvalidMaxSizeError, "The string 'bar' cannot fit into a column 6 chars wide")
      end
      
      it "should raise an error with the correct number of chars passed" do
        lambda {
          @outputer.output("bar", 2)
        }.should raise_error(OutputFormatter::ColumnOutputer::InvalidMaxSizeError, "The string 'bar' cannot fit into a column 2 chars wide")
      end
    end
  end
end
