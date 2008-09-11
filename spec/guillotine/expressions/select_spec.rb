require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe Select do
      describe "to_sql" do
        it "should be 'SELECT col1 for one column" do
          col1 = Column.new(:foo)
          Select.new(col1).to_sql.should == "SELECT foo"
        end
        
        it "should use the correct column name (the column's to_sql method)" do
          column = mock('a column', :to_sql => "foo.bar")
          Select.new(column).to_sql.should == "SELECT foo.bar"
        end
        
        it "should join multiple columns with commas" do
          column_one = mock("col 1", :to_sql => "col1")
          column_two = mock("col 2", :to_sql => "col2")
          Select.new(column_one, column_two).to_sql.should == "SELECT col1, col2"
        end
      end
    end
  end
end
