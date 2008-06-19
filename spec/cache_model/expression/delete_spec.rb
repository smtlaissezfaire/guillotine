require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  module Expression
    describe DeleteStatement do
      before :each do
        @where = mock('where clause')
        @order_by = mock("order by clause")
        @limit = mock("limit clause")
        
        @delete = DeleteStatement.new(:foo_bar, @where, @order_by, @limit)
      end
      
      it "should have the table name" do
        statement = DeleteStatement.new(:foo_bar)
        statement.table_name.should equal(:foo_bar)
      end
      
      it "should have the correct table name" do
        statement = DeleteStatement.new(:foo_bar_baz)
        statement.table_name.should equal(:foo_bar_baz)
      end
      
      it "should have the table name as a symbol, even if given a string" do
        statement = DeleteStatement.new("a_string")
        statement.table_name.should equal(:a_string)
      end
      
      it "should have a where clause as the second param" do
        @delete.where.should == @where
      end
      
      it "should have the order by clause as the third param" do
        @delete.order_by.should == @order_by
      end
      
      it "should have the limit clause as the forth param" do
        @delete.limit.should == @limit
      end
      
      describe "equality (with ==)" do
        it "should be true with the same table names" do
          one = DeleteStatement.new(:foo)
          two = DeleteStatement.new("foo")
          one.should == two
          two.should == one
        end
        
        it "should be false with different table names" do
          one = DeleteStatement.new(:foo)
          two = DeleteStatement.new("foobar")
          one.should_not == two
          two.should_not == one
        end
        
        it "should be false if one has a where, while the other doesn't" do
          one = DeleteStatement.new(:foo, @where)
          two = DeleteStatement.new(:foo)
          one.should_not == two
          two.should_not == one
        end
        
        it "should be false if one has an order by clause, when the other doesn't" do
          one = DeleteStatement.new(:foo, nil, @order_by)
          two = DeleteStatement.new(:foo)
          one.should_not == two
          two.should_not == one
        end
        
        it "should be false if one has a limit clause, when the other doesn't" do
          one = DeleteStatement.new(:foo, nil, nil, @limit)
          two = DeleteStatement.new(:foo)
          one.should_not == two
          two.should_not == one
        end
      end
      
      describe "call" do
        before :each do
          @delete = DeleteStatement.new(:foo)
          @array = [1, 2, 3]
        end
        
        it "should return an empty array" do
          @delete.call(@array).should be_empty
        end
        
        it "should destructively clear the array" do
          @delete.call(@array)
          @array.should be_empty
        end
      end
    end
  end
end
