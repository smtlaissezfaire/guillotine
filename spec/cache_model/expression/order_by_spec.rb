require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  module Expression
    describe OrderBy do
      
    end
    
    describe OrderByPair do
      it "should initialize with a column" do
        OrderByPair.new(:foo).column.should == :foo
      end
      
      it "should use a symbol for the column (even if given a string)" do
        OrderByPair.new("foobar").column.should == :foobar
      end
      
      it "should have the sort as :DESC when specificed" do
        OrderByPair.new("foobar", OrderBy::DESC).sort.should == :DESC
      end
      
      it "should have the sort as :ASC when specificed" do
        OrderByPair.new("foobar", OrderBy::ASC).sort.should == :ASC
      end
      
      it "should have ASC as the default sort option" do
        OrderByPair.new("foobar").sort.should == :ASC
      end
      
      describe "==" do
        it "should be equal to a different pair if it has the same column and sorts" do
          one = OrderByPair.new(:foo, OrderBy::ASC)
          two = OrderByPair.new(:foo, OrderBy::ASC)
          one.should == two
          two.should == one
        end
        
        it "should not be equal to another if it does not have the same column (but it has the same sort)" do
          one = OrderByPair.new(:foo, OrderBy::ASC)
          two = OrderByPair.new(:bar, OrderBy::ASC)
          one.should_not == two
          two.should_not == one
        end
        
        it "should not be equal to another if it does not have the same sort (but it has the same column)" do
          one = OrderByPair.new(:foo, OrderBy::ASC)
          two = OrderByPair.new(:foo, OrderBy::DESC)
          one.should_not == two
          two.should_not == one
        end
        
        it "should not be equal to a generic object (and it should not raise an error)" do
          two = Object.new
          one = OrderByPair.new(:foo)
          one.should_not == two
          two.should_not == one
        end
      end
    end
  end
end

