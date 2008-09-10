require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe GroupBy do
      before :each do
        @column_one = mock 'column'
        @column_two = mock 'column'
      end
      
      it "should have a column, if given one" do
        GroupBy.new(@column_one).column.should == @column_one
      end
      
      it "should have multiple columns, if initialized with them" do
        GroupBy.new(@column_one, @column_two).columns.should == [@column_one, @column_two]
      end
      
      it "should return all the columns if #column is called, and multiple columns where given in the constructor" do
        GroupBy.new(@column_one, @column_two).column.should == [@column_one, @column_two]
      end
      
      describe "==" do
        it "should be true if the other expression has the same (==) elements (in the same order)" do
          one = GroupBy.new(@column_one, @column_two)
          two = GroupBy.new(@column_one, @column_two)
          one.should == two
          two.should == one
        end
        
        it "should be false if the other has the same elements, in a different order" do
          one = GroupBy.new(@column_two, @column_one)
          two = GroupBy.new(@column_one, @column_two)
          one.should_not == two
          two.should_not == one
        end
      end
    end
  end
end

  
