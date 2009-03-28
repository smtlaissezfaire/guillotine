require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe "CREATE TABLE" do
      include ParserSpecHelper
      
      before :each do
        @parser = LemonSQLParser.new
        
        @column = mock 'column definition'
        Expressions::ColumnDefinition.stub!(:new).and_return @column
        
        @create_table = mock 'create table'
        Expressions::CreateTable.stub!(:new).and_return @create_table
      end

      it "should parse a simple create table with one column" do
        parse("CREATE TABLE foo (foo BIT)").should_not be_nil
      end

      it "should not parse 'fooasdfasdfas'" do
        parse("asdfasdfasdasdzxcvasd").should be_nil
      end

      it "should not parse any random string" do
        parse('asdasdscvw3').should be_nil
      end
      
      it "should instantiate a create table" do
        Expressions::CreateTable.should_receive(:new).and_return @create_table
        parse_and_eval("CREATE TABLE foo (foo BIT)")
      end
      
      it "should instantiate with a table name" do
        Expressions::CreateTable.should_receive(:new).with("foo", [@column]).and_return @create_table
        parse_and_eval("CREATE TABLE foo (foo BIT)")
      end
      
      it "should instantiate with the correct table name" do
        Expressions::CreateTable.should_receive(:new).with("bar", [@column]).and_return @create_table
        parse_and_eval("CREATE TABLE bar (foo BIT)")
      end
      
      it "should receive one column" do
        Expressions::Column.stub!(:new).and_return @column
        Expressions::CreateTable.should_receive(:new).with("bar", [@column]).and_return @create_table
        parse_and_eval("CREATE TABLE bar (foo BIT)")
      end
      
      it "should instantiate with two columns in an array" do
        Expressions::Column.stub!(:new).and_return @column
        Expressions::CreateTable.should_receive(:new).with("bar", [@column, @column]).and_return @create_table
        parse_and_eval("CREATE TABLE bar (foo BIT, bar BIT)")
      end
      
      it "should parse it with any number of spaces" do
        parse("CREATE   TABLE   foo (foo BIT)").should_not be_nil
      end

      it "should not parse with 'CREATETABLE'" do
        pending "FIXME"
        parse("CREATETABLE foo (foo BIT)").should be_nil
      end
      
      it "should allow an arbitrary table name" do
        parse("CREATE TABLE bar (foo BIT)").should_not be_nil
      end

      it "should allow any arbitrary table name" do
        parse("CREATE TABLE foos (foo BIT)").should_not be_nil
      end

      it "should allow backquoting of the tablename" do
        parse("CREATE TABLE   `bar` (foo BIT)").should_not be_nil
      end
      
      it "should allow any table name backquoted" do
        parse("CREATE   TABLE   `something` (foo BIT)").should_not be_nil        
      end
      
      it "should allow a different column name" do
        parse("CREATE TABLE foo (bar BIT)").should_not be_nil
      end
      
      it "should allow backticking of the column name" do
        parse("CREATE TABLE foo (`bar` BIT)").should_not be_nil
      end
      
      it "should allow spaces between the open parens" do
        parse("CREATE TABLE foo   (foo BIT)").should_not be_nil
      end

      it "should allow spaces in front of the of the open paren" do
        parse("CREATE TABLE foo   (    foo BIT)").should_not be_nil
      end
      
      it "should allow space before the closing parens" do
        parse("CREATE TABLE foo (foo BIT  )").should_not be_nil
      end
      
      it "should allow an int" do
        parse("CREATE TABLE foo ( foo INT (11))").should_not be_nil
      end
      
      it "should allow any amount of whitespace between the column name and the type" do
        parse("CREATE TABLE foo ( foo       INT (11))").should_not be_nil        
      end
      
      it "should allow two sets of columns" do
        parse("CREATE TABLE foo (foo BIT, foo BIT)").should_not be_nil
      end
      
      it "should allow spaces betwee the first definition and the comma" do
        parse("CREATE TABLE foo (foo BIT   , foo BIT)").should_not be_nil
      end
    end
  end
end
