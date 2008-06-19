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
    end
  end
end

