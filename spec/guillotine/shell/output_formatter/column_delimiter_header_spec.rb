require File.dirname(__FILE__) + "/../../../spec_helper"

module Guillotine
  module Shell
    describe OutputFormatter::ColumnDelimiterHeader do
      before(:each) do
        @outputer = OutputFormatter::ColumnDelimiterHeader
      end
      
      it "should output +--- when given the number 1" do
        @outputer.output(1).should == "+---"
      end
      
      it "should output +---- when given the number 2"do
        @outputer.output(2).should == "+----"
      end
      
      it "should output +---+ when passed '1' (char), and 'true' for being the last column" do
        @outputer.output(1, true).should == "+---+"
      end
    end
  end
end
