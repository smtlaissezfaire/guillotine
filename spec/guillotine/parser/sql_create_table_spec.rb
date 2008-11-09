require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLCreateTableParser do
      include ParserSpecHelper
      
      before :each do
        @parser = SQLCreateTableParser.new
      end
      
      it "should parse a simple create table with one column" do
        parse("CREATE TABLE foo (foo bit)").should_not be_nil
      end
      
      it "should parse it with any number of spaces" do
        parse("CREATE   TABLE   foo (foo bit)").should_not be_nil
      end
      
      it "should allow an arbitrary table name" do
        parse("CREATE   TABLE   bar (foo bit)").should_not be_nil
      end
      
      it "should allow backquoting of the tablename" do
        parse("CREATE   TABLE   `bar` (foo bit)").should_not be_nil
      end
    end
  end
end
