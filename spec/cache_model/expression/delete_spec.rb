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
        describe "with only the table name and no conditions" do
          before :each do
            @delete = DeleteStatement.new(:foo)
            @array = [1, 2, 3]
            @truncate = Truncate.new(:foo)
          end
          
          it "should return an empty array" do
            @delete.call(@array).should be_empty
          end
          
          it "should destructively clear the array" do
            @delete.call(@array)
            @array.should be_empty
          end
          
          it "should call truncate with the right constructor argument" do
            delete = DeleteStatement.new(:foo_bar)
            Truncate.should_receive(:new).with(:foo_bar).and_return @truncate
            delete.call(@array)
          end
          
          it "should truncate the table" do
            Truncate.should_receive(:new).with(:foo).and_return @truncate
            @truncate.should_receive(:call).with([1,2,3]).and_return []
            @delete.call(@array)
          end
        end
        
        describe "with a limit clause, with three elements in the table" do
          before :each do
            @array = [1,2,3]
          end
          
          describe "with a limit of 1" do
            before :each do
              @limit = Limit.new(1)
              @delete = DeleteStatement.new(:table_name, nil, nil, @limit)
            end
            
            it "should remove the first element with a limit 1" do
              @delete.call(@array)
              @array.should == [2,3]
            end
              
            it "should return the second and third elements of the table with a limit of 1" do
              @delete.call(@array).should == [2, 3]
            end
          end
          
          describe "with a limit of 2" do
            before :each do
              @limit = Limit.new(2)
              @delete = DeleteStatement.new(:table_name, nil, nil, @limit)
            end
            
            it "should remove the first and second elements with a limit of 2" do
              @delete.call(@array)
              @array.should == [3]
            end
              
            it "should return the third element of the table with a limit of 1" do
              @delete.call(@array).should == [3]
            end
          end
          
          describe "with a limit of 3" do
            before :each do
              @limit = Limit.new(3)
              @delete = DeleteStatement.new(:table_name, nil, nil, @limit)
            end
            
            it "should remove the whole array" do
              @delete.call(@array)
              @array.should be_empty
            end
              
            it "should return an empty array" do
              @delete.call(@array).should be_empty
            end
          end
          
          describe "with a limit of 4" do
            before :each do
              @limit = Limit.new(4)
              @delete = DeleteStatement.new(:table_name, nil, nil, @limit)
            end
            
            it "should remove the whole array" do
              @delete.call(@array)
              @array.should be_empty
            end
              
            it "should return an empty array" do
              @delete.call(@array).should be_empty
            end
          end
          
          describe "with a limit of 0" do
            before :each do
              @limit = Limit.new(0)
              @delete = DeleteStatement.new(:table_name, nil, nil, @limit)
            end
            
            it "should NOT change the array" do
              @delete.call(@array)
              @array.should == [1,2,3]
            end
              
            it "should return the array" do
              @delete.call(@array).should == [1,2,3]
            end
          end
        end
        
        describe "calling with order by and limit" do
          before :each do
            @collection = [{ :foo => "bar", :id => 3}, { :foo => "bar", :id => 2}]
            order_by = Expression::OrderBy.new(OrderByPair.new(:id, :ASC))
            @delete = DeleteStatement.new(:table_name, nil, order_by, Limit.new(1))
          end
          
          it "should return the results with the first element deleted by the order clause" do
            @delete.call(@collection).should == [{ :foo => "bar", :id => 3}]
          end
          
          it "should modify the array given" do
            @delete.call(@collection)
            @collection.should == [{ :foo => "bar", :id => 3}]
          end
        end
      end
    end
  end
end
