require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  describe SQLOrderByClauseParser do
    include ParserSpecHelper

    before :each do
      @parser = SQLOrderByClauseParser.new
    end

    it "should order by a column name" do
      pair = Expression::OrderByPair.new(:column)
      result = Expression::OrderBy.new(pair)
      parse_and_eval("ORDER BY column").should == result
    end
    
    it "should order by a different name" do
      pair = Expression::OrderByPair.new(:different_col)
      result = Expression::OrderBy.new(pair)
      parse_and_eval("ORDER BY different_col").should == result
    end
    
    it "should order by two columns" do
      pair1 = Expression::OrderByPair.new(:different_col)
      pair2 = Expression::OrderByPair.new(:column_two)
      result = Expression::OrderBy.new(pair1, pair2)
      parse_and_eval("ORDER BY different_col, column_two").should == result
    end
    
    it "should allow any number of spaces after the ORDER BY clause" do
      pair1 = Expression::OrderByPair.new(:different_col)
      pair2 = Expression::OrderByPair.new(:column_two)
      result = Expression::OrderBy.new(pair1, pair2)
      parse_and_eval("ORDER BY             different_col, column_two").should == result
    end
    
    it "should not parse ORDER BYcolumn_name" do
      parse("ORDER BYcolumn_name").should be_nil
    end
    
    it "should parse ORDER BY col_one,   column_two" do
      parse("ORDER BY col_one,   col_two").should_not be_nil
    end
    
    it "should parse ORDER BY column_name ASC" do
      parse("ORDER BY column_name ASC").should_not be_nil
    end
    
    it "should parse ORDER BY column_name DESC" do
      parse("ORDER BY column_name DESC").should_not be_nil
    end
    
    it "should parse ORDER BY column_name     DESC" do
      parse("ORDER BY column_name       DESC").should_not be_nil
    end
    
    it "should parse ORDER BY col_one, col_two DESC" do
      parse("ORDER BY col_one, col_two DESC").should_not be_nil
    end
    
    it "should parse ORDER BY col_one DESC, col_two" do
      parse("ORDER BY col_one DESC, col_one").should_not be_nil
    end

  end
end
