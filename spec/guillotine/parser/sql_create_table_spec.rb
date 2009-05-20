require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLGazelleParser do
      before :each do
        @parser = SQLGazelleParser
        @column = mock 'column'
        @create_table = mock 'create table'
      end
      
      def parse(str)
        @parser.parse?(str)
      end
      
      def parse_and_eval(str)
        @parser.parse(str)
      end
      
      it "should parse a simple create table with one column" do
        parse("CREATE TABLE foo (foo BIT)").should_not be_nil
      end
      
      it "should be able to use a different table name" do
        parse("CREATE TABLE bar (foo BIT)").should_not be_nil
      end
      
      it "should be able to really use any table name" do
        parse("CREATE TABLE some_third_tablename (foo BIT)").should_not be_nil
      end
      
      it "should be able to use a different column name" do
        parse("CREATE TABLE foo (bar BIT)").should_not be_nil
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
      
      it "should not parse without a comma between two definitions" do
        pending "FIXME"
        parse("CREATE TABLE foo (foo BIT foo BIT)").should be_nil
      end
      
      it "should allow spaces betwee the first definition and the comma" do
        parse("CREATE TABLE foo (foo BIT   , foo BIT)").should_not be_nil
      end
    
      it "should instantiate a create table" do
        Expressions::CreateTable.should_receive(:new).and_return @create_table
        parse_and_eval("CREATE TABLE foo (bar BIT)")
      end
      
      it "should instantiate with a table name" do
        Expressions::CreateTable.should_receive(:new).with(hash_including(:table_name => "foo"))
        parse_and_eval("CREATE TABLE foo (foo BIT)")
      end

      it "should instantiate with a table name" do
        Expressions::CreateTable.should_receive(:new).with(hash_including(:table_name => "bar"))
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
    end
  end
end
