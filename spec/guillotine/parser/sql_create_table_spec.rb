require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLCreateTableParser do
      include ParserSpecHelper
      
      before :each do
        @parser = SQLCreateTableParser.new
        @column = mock 'column'
        @create_table = mock 'create table'
        Expressions::CreateTable.stub!(:new).and_return @create_table
      end
      
      it "should parse a simple create table with one column" do
        parse("CREATE TABLE foo (foo BIT)").should_not be_nil
      end
      
      it "should instantiate a create table" do
        Expressions::CreateTable.should_receive(:new).and_return @create_table
        parse_and_eval("CREATE TABLE foo (foo BIT)")
      end
      
      it "should instantiate with a table name" do
        Expressions::CreateTable.should_receive(:new).with(hash_including(:table_name => "foo")).and_return @create_table
        parse_and_eval("CREATE TABLE foo (foo BIT)")
      end
      
      it "should instantiate with the correct table name" do
        Expressions::CreateTable.should_receive(:new).with(hash_including(:table_name => "bar")).and_return @create_table
        parse_and_eval("CREATE TABLE bar (foo BIT)")
      end
      
      it "should receive one column" do
        Expressions::Column.stub!(:new).and_return @column
        Expressions::CreateTable.should_receive(:new).with(hash_including(:columns => [@column])).and_return @create_table
        parse_and_eval("CREATE TABLE bar (foo BIT)")
      end
      
      it "should instantiate with two columns in an array" do
        Expressions::Column.stub!(:new).and_return @column
        Expressions::CreateTable.should_receive(:new).with(hash_including(:columns => [@column, @column])).and_return @create_table
        parse_and_eval("CREATE TABLE bar (foo BIT, bar BIT)")
      end
      
      it "should parse it with any number of spaces" do
        parse("CREATE   TABLE   foo (foo BIT)").should_not be_nil
      end
      
      it "should allow an arBITrary table name" do
        parse("CREATE   TABLE   bar (foo BIT)").should_not be_nil
      end
      
      it "should allow backquoting of the tablename" do
        parse("CREATE   TABLE   `bar` (foo BIT)").should_not be_nil
      end
      
      it "should allow a different column name" do
        parse("CREATE TABLE foo (bar BIT)").should_not be_nil
      end
      
      it "should allow backticking of the column name" do
        parse("CREATE TABLE foo (`bar` BIT)").should_not be_nil
      end
      
      it "should allow spaces between the open parens" do
        parse("CREATE TABLE foo   (   foo BIT)").should_not be_nil
      end
      
      it "should allow space after the parens" do
        parse("CREATE TABLE foo (foo BIT  )").should_not be_nil
      end
      
      it "should allow an int" do
        parse("CREATE TABLE foo ( foo INT (11))").should_not be_nil
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
