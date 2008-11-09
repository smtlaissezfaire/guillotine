require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLParser do
      include ParserSpecHelper

      before :each do
        @parser = SQLParser.new
      end
      
      it "should parse a SELECT statement" do
        parse("SELECT * FROM events").should_not be_nil
      end
      
      it "should parse a DELETE statement" do
        parse("DELETE FROM events").should_not be_nil
      end
      
      it "should parse a TRUNCATE TABLE statement" do
        parse("TRUNCATE TABLE events").should_not be_nil
      end
      
      it "should parse a DROP TABLE statement" do
        parse("DROP TABLE events").should_not be_nil
      end
      
      it "should parse a transaction" do
        parse("START TRANSACTION").should_not be_nil
      end
      
      it "should parse an INSERT statement" do
        parse("INSERT INTO foo VALUES (1, 2)").should_not be_nil
      end
      
      it "should parse a SHOW TABLES expression" do
        parse("SHOW TABLES").should_not be_nil
      end
      
      it "should parse a CREATE TABLE statement" do
        parse("CREATE TABLE `foo` (id INT(11))").should_not be_nil
      end
    end
  end
end
