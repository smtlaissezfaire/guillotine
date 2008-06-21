require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  describe SQLDeleteParser do
    include ParserSpecHelper

    before :each do
      @parser = SQLDeleteParser.new
    end
    
    it "should parse DELETE FROM table_name" do
      parse("DELETE FROM table_name").should_not be_nil
    end
    
    it "should parse and eval DELETE FROM table_name" do
      parse_and_eval("DELETE FROM table_name").should == Expression::DeleteStatement.new(:table_name)
    end
    
    it "should parse DELETE FROM another_table_name" do
      parse("DELETE FROM another_table_name").should_not be_nil
    end
    
    it "should parse and eval DELETE FROM another_table_name" do
      parse_and_eval("DELETE FROM another_table_name").should == Expression::DeleteStatement.new(:another_table_name)
    end
    
    it "should take any number of spaces after the delete" do
      parse("DELETE           FROM another_table_name").should_not be_nil
    end
    
    it "should take any number of spaces after the FROM" do
      parse("DELETE FROM                  another_table_name").should_not be_nil
    end
    
    it "should take an optional where clause" do
      parse("DELETE FROM table_name WHERE foo=bar").should_not be_nil
    end
    
    it "should eval with an optional where clause" do
      equal_expression = Expression::Equal.new(:foo, "bar")
      parse_and_eval("DELETE FROM table_name WHERE foo=bar").should == Expression::DeleteStatement.new(:table_name, equal_expression)
    end
    
    it "should take a where clause with any number of spaces before the WHERE" do
      parse("DELETE FROM table_name              WHERE foo=bar").should_not be_nil
    end

    it "should parse an optional order by clause" do
      parse("DELETE FROM table_name ORDER BY foo").should_not be_nil
    end
    
    it "should parse an optional order by clause" do
      order_by_clause = Expression::OrderBy.new(Expression::OrderByPair.new(:foo))
      parse_and_eval("DELETE FROM table_name ORDER BY foo").should == Expression::DeleteStatement.new(:table_name, nil, order_by_clause)
    end
    
    it "should parse an optional order by clause with many spaces in it" do
      parse("DELETE FROM table_name          ORDER BY foo").should_not be_nil      
    end
    
    it "should have order by with many spaces" do
      parse("DELETE FROM table_name          ORDER         BY foo").should_not be_nil      
    end
    
    it "should have an optional limit" do
      parse("DELETE FROM table_name LIMIT 1").should_not be_nil
    end
    
    it "should eval with an optional limit" do
      limit = Expression::Limit.new(1)
      parse_and_eval("DELETE FROM table_name LIMIT 1").should == Expression::DeleteStatement.new(:table_name, nil, nil, limit)
    end
    
    it "should have an optional limit with spaces" do
      parse("DELETE FROM table_name                  LIMIT            1").should_not be_nil
    end
    
    it "should parse DELETE with the low proiority key word" do
      parse("DELETE LOW_PRIORITY FROM table_name").should_not be_nil
    end
    
    it "should parse DELETE with the low proiority key word (with spaces)" do
      parse("DELETE    LOW_PRIORITY            FROM table_name").should_not be_nil
    end
    
    it "should parse the optional QUICK keyword" do
      parse("DELETE QUICK FROM table_name").should_not be_nil      
    end

    it "should parse the optional QUICK keyword with spaces" do
      parse("DELETE     QUICK          FROM table_name").should_not be_nil      
    end
    
    it "should parse the optional IGNORE keyword" do
      parse("DELETE IGNORE FROM table_name").should_not be_nil      
    end

    it "should parse the optional IGNORE keyword with spaces" do
      parse("DELETE     IGNORE          FROM table_name").should_not be_nil      
    end
  end
end
