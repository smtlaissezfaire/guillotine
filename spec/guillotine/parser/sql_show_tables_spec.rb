require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLShowTablesParser do
      include ParserSpecHelper
      
      before :each do
        @parser = SQLShowTablesParser.new
        @displayer = mock 'displayer'
        Expressions::TableDisplayer.stub!(:new).and_return @displayer
      end
      
      it "should parse 'SHOW TABLES'" do
        parse("SHOW TABLES").should_not be_nil
      end
      
      it "should instantiate a table displayer with the datastore" do
        Expressions::TableDisplayer.should_receive(:new).with(Guillotine::DataStore)
        parse_and_eval("SHOW TABLES")
      end
      
      it "parse with the FULL keyword" do
        parse("SHOW FULL TABLES").should_not be_nil
      end
      
      it "should parse with spaces" do
        parse("SHOW   FULL   TABLES").should_not be_nil
      end
      
      it "should parse with a table_name" do
        parse("SHOW TABLES FROM a_table").should_not be_nil
      end
      
      it "should parse with a table_name (with space)" do
        parse("SHOW TABLES     FROM      a_table").should_not be_nil
      end
      
      it "should parse the LIKE clause" do
        parse("SHOW TABLES LIKE 'foo'").should_not be_nil
      end
      
      it "should parse the LIKE clause with spaces behind the the LIKE" do
        parse("SHOW TABLES          LIKE 'foo'").should_not be_nil
      end
      
      it "should parse the LIKE clause with spaces in front of the " do
        parse("SHOW TABLES LIKE                 'foo'").should_not be_nil
      end
      
      it "should parse the LIKE clause with a different single quoted string" do
        parse("SHOW TABLES LIKE 'bar'").should_not be_nil
      end
      
      it "should parse a WHERE clause"do
        parse("SHOW TABLES WHERE foo = 'bar'").should_not be_nil
      end
      
      it "should not parse a like clause and a where clause" do
        parse("SHOW TABLES LIKE 'bar' WHERE foo = 'bar'").should be_nil
      end
    end
  end
end
