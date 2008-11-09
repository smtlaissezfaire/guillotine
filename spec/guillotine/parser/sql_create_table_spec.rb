require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLCreateTableParser do
      include ParserSpecHelper
      
      before :each do
        @parser = SQLCreateTableParser.new
      end
      
      it "should parse a simple create table with one column" do
        parse("CREATE TABLE foo (foo BIT)").should_not be_nil
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
