require File.dirname(__FILE__) + "/../../../spec_helper"

module Guillotine
  module Shell
    describe OutputFormatter::ColumnLengthCalculator do
      before(:each) do
        @calculator = Class.new do
          include OutputFormatter::ColumnLengthCalculator
        end.new
      end
      
      it "should find the size of '3' with a column name one char long (the size + offset)" do
        @calculator.size_of_column(:a, [{ :a => "" }]).should == 3
      end
      
      it "should find the size of '4' with a column name two chars long" do
        @calculator.size_of_column(:ab, [{ :ab => "" }]).should == 4
      end
      
      it "should find the size of '5' with a column name one char long, and a value of 3 chars" do
        @calculator.size_of_column(:a, [{ :a => "123" }]).should == 5
      end
      
      it "should use the size of the correct column" do
        @calculator.size_of_column(:abc, [{ :b => "", :abc => "" }]).should == 5
      end
      
      it "should use the size of the correct column value" do
        @calculator.size_of_column(:b, [{ :a => "", :b => "4567" }]).should == 6
      end
      
      it "should to_s the value" do
        @calculator.size_of_column(:a, [{ :a => 1 }]).should == 3
      end
      
      it "should pick the longest column out of a range of column values" do
        @calculator.size_of_column(:a, [{ :a => "1" }, { :a => "12"}]).should == 4
      end
    end
  end
end
