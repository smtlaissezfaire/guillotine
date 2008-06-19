require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  describe SQLOrderByClauseParser do
    include ParserSpecHelper

    before :each do
      @parser = SQLOrderByClauseParser.new
    end

    it "should order by a column name" do
      result = Expression::OrderBy.new("column")
      parse_and_eval("ORDER BY column").should == result
    end
    
    it "should order by a different name" do
      result = Expression::OrderBy.new("different_col")
      parse_and_eval("ORDER BY different_col").should == result
    end
    
    it "should order by two columns" do
      result = Expression::OrderBy.new("different_col", 'column_two')
      parse_and_eval("ORDER BY different_col, column_two").should == result
    end
    
    it "should allow any number of spaces after the ORDER BY clause" do
      result = Expression::OrderBy.new("different_col", 'column_two')
      parse_and_eval("ORDER BY             different_col, column_two").should == result
    end
    
    it "should not parse ORDER BYcolumn_name" do
      parse("ORDER BYcolumn_name").should be_nil
    end
    
    it "should parse ORDER BY col_one,   column_two" do
      parse("ORDER BY col_one,   col_two").should_not be_nil
    end
    
    it "should parse ORDER BY column_name ASC" do
      pending 'todo'
      parse("ORDER BY column_name ASC").should_not be_nil
    end
    
    it "should parse ORDER BY column_name DESC"
    
    it "should parse ORDER BY col_one, col_two DESC"
    
    it "should parse ORDER BY col_one DESC, col_two"

  end
end
