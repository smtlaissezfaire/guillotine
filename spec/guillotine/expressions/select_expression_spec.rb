require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe SelectExpression do
      it "should have the query string" do
        SelectExpression.new(:string => "foo bar").query_string.should == "foo bar"
      end
      
      it "should have the proper query string" do
        SelectExpression.new(:string => "SELECT * FROM events").query_string.should == "SELECT * FROM events"
      end
      
      it "should have a pretty inspect" do
        query = "SELECT * FROM events"
        expr = SelectExpression.new(:string => query)
        expr.inspect.should == "Guillotine::Expressions::SelectExpression: SELECT * FROM events"
      end
      
      describe "call" do
        before :each do
          @select_clause = mock("select clause")
          @from = mock("from clause")
          @limit = mock("limit")
        end
        
        describe "with no conditions" do
          before :each do
            @select = SelectExpression.new({ 
              :select => @select_clause,
              :from   => @from,
            })
            @array = [1, 2, 3]
          end
        
          it "should return all the results" do
            @select.call(@array).should == @array
          end
        end
        
        describe "with a limit clause, with three elements in the table" do
          before :each do
            @array = [1,2,3]
          end
          
          describe "with a limit of 1" do
            before :each do
              @limit = Expressions::Limit.new(1)
              @select = SelectExpression.new({ :select => @select_clause, :from => @from, :limit => @limit })
            end

            it "should return only the first element" do
              @select.call(@array).should == [1]
            end
          end
        end
        
        describe "with a limit of 2" do
          before :each do
            @array = [1,2,3]          
            @limit = Expressions::Limit.new(2)
            @select = SelectExpression.new({ :select => @select_clause, :from => @from, :limit => @limit })
          end
          
          it "should return the first two elements" do
            @select.call(@array).should == [1, 2]
          end
        end
        
        describe "with a limit of 3" do
          before :each do
            @array = [1,2,3]          
            @limit = Expressions::Limit.new(3)
            @select = SelectExpression.new({ :select => @select_clause, :from => @from, :limit => @limit })
          end
          
          it "should return all the elements" do
            @select.call(@array).should == [1, 2, 3]
          end
        end
        
        describe "with a limit of 4" do
          before :each do
            @array = [1,2,3]
            @limit = Expressions::Limit.new(4)
            @select = SelectExpression.new({ :select => @select_clause, :from => @from, :limit => @limit })
          end
          
          it "should return all the elements" do
            @select.call(@array).should == [1, 2, 3]
          end
        end
        
        describe "with a limit of 0" do
          before :each do
            @array = [1,2,3]
            @limit = Expressions::Limit.new(0)
            @select = SelectExpression.new({ :select => @select_clause, :from => @from, :limit => @limit })
          end
          
          it "should return none of the elements" do
            @select.call(@array).should == []
          end
        end
        
        describe "calling with order by and limit" do
          before :each do
            @collection = [{ :foo => "bar", :id => 3}, { :foo => "bar", :id => 2}]
            order_by = Expressions::OrderBy.new(Expressions::OrderByPair.new(:id, :ASC))
            @limit = Expressions::Limit.new(1)
            @select = SelectExpression.new({ :select => @select_clause, :from => @from, :limit => @limit, :order_by => @order_by })
          end
          
          it "should return the results with the first matching element" do
            @select.call(@collection).should == [{ :foo => "bar", :id => 3}]
          end
        end
        
        describe "with an empty collection" do
          before :each do
            @select = SelectExpression.new({ })
          end
          
          it "should return empty" do
            @select.call([]).should be_empty
          end
        end
      end
      
      describe "to_sql" do
        before :each do
          @select = mock("select", :to_sql => "SELECT *")
          @from   = mock("from",   :to_sql => "FROM a_table")
          @where  = mock("where",  :to_sql => "WHERE something IS NOT NULL")
          @limit  = mock("limit",  :to_sql => "LIMIT 10")
          @order_by = mock("order by", :to_sql => "ORDER BY foo, bar")
        end
        
        it "should use select, from out of necessity" do
          obj = SelectExpression.new(:select => @select, :from => @from)
          obj.to_sql.should == "SELECT * FROM a_table"
        end
        
        it "should use a where clause when given" do
          obj = SelectExpression.new(:select => @select, :from => @from, :where => @where)
          obj.to_sql.should == "SELECT * FROM a_table\nWHERE something IS NOT NULL"
        end
        
        it "should use a limit clause when given" do
          obj = SelectExpression.new(:select => @select, :from => @from, :limit => @limit)
          obj.to_sql.should == "SELECT * FROM a_table\nLIMIT 10"
        end
        
        it "should use an ORDER BY clause when given" do
          obj = SelectExpression.new(:select => @select, :from => @from, :order_by => @order_by)
          obj.to_sql.should == "SELECT * FROM a_table\nORDER BY foo, bar"
        end
        
        it "should use a GROUP BY"
        
        it "should use an OFFSET"
        
        it "should transform any joins"
        
        it "should use all of them, in the right order" do
          obj = SelectExpression.new({
            :select   => @select,
            :from     => @from,
            :order_by => @order_by,
            :limit    => @limit
          })
          string = "SELECT * FROM a_table\nORDER BY foo, bar\nLIMIT 10"
          obj.to_sql.should == string
        end
      end
    end
  end
end
