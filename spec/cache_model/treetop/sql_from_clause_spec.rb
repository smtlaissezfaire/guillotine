require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  describe SQLFromClauseParser  do
    include ParserSpecHelper

    before :each do
      @parser = SQLFromClauseParser.new
    end

    it "should parse FROM table_name" do
      parse_and_eval("FROM table_name").should == Expression::From.new("table_name")
    end
    
    it "should parse FROM my_table_name" do
      parse_and_eval("FROM my_table_name").should == Expression::From.new("my_table_name")
    end
    
    it "should parse a quoted table name" do
      parse_and_eval("FROM `my_table_name`").should == Expression::From.new("my_table_name")
    end
    
    it "should parse FROM table_name with spaces between the from and the table_name" do
      parse_and_eval("FROM          table_name").should == Expression::From.new("table_name")
    end
    
    it "should parse two table names" do
      parse_and_eval("FROM table_name_one, table_name_two").should == Expression::From.new("table_name_one", "table_name_two")
    end
    
    it "should parse three table names" do
      result = Expression::From.new("table_one", "table_two", "table_three")
      parse_and_eval("FROM table_one, table_two, table_three").should == result
    end
    
    it "shuld parse table names with spaces between the commas" do
      result = Expression::From.new("table_one", "table_two", "table_three")
      parse_and_eval("FROM table_one,         table_two,    table_three").should == result
    end
  end
end
