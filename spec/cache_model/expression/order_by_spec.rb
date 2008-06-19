require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  module Expression
    describe OrderBy do
      before :each do
        @pair1 = mock 'order by pair 1'
        @pair2 = mock 'order by pair 2'
      end
      
      it "should initialize with a splatted array of OrderByPairs, and have the pairs" do
        order_by = OrderBy.new @pair1, @pair2
        order_by.pairs.should == [@pair1, @pair2]
      end
      
      it "should have the pair if given only one" do
        order_by = OrderBy.new @pair1
        order_by.pair.should == @pair1
      end
      
      it "should return the array of pairs if #pair is called, but there are multiple pairs" do
        order_by = OrderBy.new @pair1, @pair2
        order_by.pair.should == [@pair1, @pair2]
      end
      
      describe "==" do
        before :each do
          @pair_one = OrderByPair.new(:foo)
          @pair_two = OrderByPair.new(:foo)
          @pair_three = OrderByPair.new(:baz)
        end
        
        it "should be true if the other array has the same (==) elements" do
          one = OrderBy.new(@pair_one)
          two = OrderBy.new(@pair_two)
          one.should == two
          two.should == one
        end
        
        it "should be false if the other array is not the same"do
          one = OrderBy.new(@pair_one)
          two = OrderBy.new(@pair_three)
          one.should_not == two
          two.should_not == one
        end
      end
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
      
      describe "sorting (calling with a collection)" do
        describe "when ASC" do
          before :each do
            @pair = OrderByPair.new(:id, OrderByPair::ASC)
          end
          
          it "should return [{:id => 1}, {:id => 2}] unchanged" do
            collection = [{ :id => 1 }, { :id => 2 }]
            @pair.call(collection).should == collection
          end
          
          it "should return [{:id => 2}, {:id => 1}] with the id's in order" do
            collection = [{ :id => 2 }, { :id => 1 }]
            @pair.call(collection).should == [{ :id => 1 }, { :id => 2 }]
          end
        end
        
        describe "when DESC" do
          before :each do
            @pair = OrderByPair.new(:id, OrderByPair::DESC)
          end
          
          it "should return [{:id => 1}, {:id => 2}] reversed" do
            collection = [{ :id => 1 }, { :id => 2 }]
            @pair.call(collection).should == collection.reverse
          end
          
          it "should return [{:id => 2}, {:id => 1}] with the id's in reverse order" do
            collection = [{ :id => 2 }, { :id => 1 }]
            @pair.call(collection).should == [{ :id => 2 }, { :id => 1 }]
          end
        end
      end
    end
  end
end

