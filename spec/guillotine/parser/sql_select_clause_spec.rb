require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLSelectClauseParser  do
      include ParserSpecHelper

      before :each do
        @parser = SQLSelectClauseParser.new
      end
      
      it "should parse SELECT *" do
        parse_and_eval("SELECT *").should == Expressions::Select.new("*")
      end
      
      it "should parse SELECT * (with spaces in front of the star)" do
        parse_and_eval("SELECT    *").should == Expressions::Select.new("*")
      end
      
      it "should parse SELECT * (with spaces at the end of the star)" do
        parse_and_eval("SELECT    *        ").should == Expressions::Select.new("*")
      end
      
      it "should not parse SELECT*" do
        parse("SELECT*").should be_nil
      end
      
      it "should parse SELECT column_name" do
        parse_and_eval("SELECT column_name").should == Expressions::Select.new("column_name")
      end
      
      it "should parse SELECT column_name1" do
        pending 'todo'
        parse_and_eval("SELECT column_name1").should == Expressions::Select.new("column_name1")
      end
      
      it "should parse SELECT my_column_name" do
        parse_and_eval("SELECT my_column_name").should == Expressions::Select.new("my_column_name")
      end
      
      it "should parse SELECT table_name.column_name" do
        parse_and_eval("SELECT table_name.column_name").should == Expressions::Select.new("table_name.column_name")
      end
      
      it "should parse SELECT `table_name`.column_name" do
        parse_and_eval("SELECT `table_name`.column_name").should == Expressions::Select.new("table_name.column_name")
      end
      
      it "should parse SELECT column_one, column_two" do
        parse("SELECT column_one, column_two").should_not be_nil
      end
      
      it "should parse SELECT column_one, column_two" do
        parse_and_eval("SELECT column_one, column_two").should == Expressions::Select.new("column_one", "column_two")
      end
      
      it "should parse SELECT table_name.column_one, table_name.column_two" do
        parse_and_eval("SELECT table_name.column_one, `table_name`.column_two").should == Expressions::Select.new("table_name.column_one", "table_name.column_two")
      end
      
      it "should parse three columns" do
        parse_and_eval("SELECT column_one, column_two, column_three").should == Expressions::Select.new("column_one", "column_two", "column_three")
      end
      
      it "should parse columns with mixed *'s and table names" do
        results = Expressions::Select.new("foo.column_one", "bar.*", "baz.column_three")
        parse_and_eval("SELECT foo.column_one, bar.*, baz.column_three").should == results
      end
    end
  end
end
