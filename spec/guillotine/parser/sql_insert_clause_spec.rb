require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLInsertParser do
      include ParserSpecHelper

      before :each do
        @parser = SQLInsertParser.new
      end
      
      describe "mysql's first form" do
        it "should parse 'INSERT INTO users VALUES (1)" do
          parse("INSERT INTO users VALUES (1)").should_not be_nil
        end
        
        it "should parse and eval 'INSERT INTO users VALUES (1)" do
          insert = Insert.new(:into => :users, :values => [1])
          parse_and_eval("INSERT INTO users VALUES (1)").should == insert
        end
        
        it "should parse and eval 'INSERT INTO foo VALUES (1)" do
          insert = Insert.new(:into => :foo, :values => [1])
          parse_and_eval("INSERT INTO foo VALUES (1)").should == insert
        end
        
        it "should parse and eval 'INSERT INTO foo VALUES ()" do
          insert = Insert.new(:into => :foo, :values => [])
          parse_and_eval("INSERT INTO foo VALUES ()").should == insert
        end
        
        it "should parse and eval 'INSERT INTO foo VALUES (1, 1)" do
          insert = Insert.new(:into => :foo, :values => [1, 2])
          parse_and_eval("INSERT INTO foo VALUES (1, 2)").should == insert
        end
        
        it "should parse and eval two values, with a different set of values" do
          insert = Insert.new(:into => :foo, :values => [3,2])
          parse_and_eval("INSERT INTO foo VALUES (3,2)").should == insert
        end
        
        it "should not parse 'foo bar'" do
          parse("foo bar").should be_nil
        end
        
        it "should parse 'INSERT INTO users VALUES (2)" do
          parse("INSERT INTO users VALUES (2)").should_not be_nil
        end
        
        it "should parse and eval 'INSERT INTO users VALUES (2)" do
          insert = Insert.new(:into => :users, :values => [2])
          parse_and_eval("INSERT INTO users VALUES (2)").should == insert
        end
        
        it "should parse one value, which is a number" do
          parse('INSERT INTO users VALUES (3)').should_not be_nil
        end
        
        it "should parse one value, which is any sort of primitive" do
          parse('INSERT INTO users VALUES (TRUE)').should_not be_nil
        end
        
        it "should parse two primitives in the VALUES clause, seperated by a comma" do
          parse("INSERT INTO users VALUES (TRUE, TRUE)").should_not be_nil
        end
        
        it "should parse two primitives, with no spaces between the two primitves with the comma" do
          parse("INSERT INTO users VALUES (TRUE,TRUE)").should_not be_nil
        end
        
        it "should parse and eval two true statements" do
          pending 'todo'
          insert = Insert.new(:into => :users, :values => [true, true])
          parse("INSERT INTO users VALUES (TRUE,TRUE)").should == insert
        end
        
        it "should parse two primitvies, with lots of spaces between the two primitives" do
          parse("INSERT INTO users VALUES (TRUE          ,      TRUE)").should_not be_nil
        end
        
        it "should parse three primitives" do
          parse("INSERT INTO users VALUES (TRUE, FALSE, 7)").should_not be_nil
        end
        
        it "should parse with a unique table name" do
          parse("INSERT INTO a_table_name VALUES (TRUE)").should_not be_nil
        end
        
        it "should parse a quoted table name" do
          parse("INSERT INTO `foo` VALUES (TRUE)").should_not be_nil
        end
        
        it "should parse when given no values" do
          parse("INSERT INTO foo VALUES ()").should_not be_nil
        end
        
        it "should parse with spaces between INSERT and INTO" do
          parse("INSERT          INTO foo VALUES ()").should_not be_nil
        end
        
        it "should parse with spaces betwen INTO and the table name" do
          parse("INSERT INTO     foo VALUES ()").should_not be_nil
        end
        
        it "should parse with spaces between the table name and the VALUES clause" do
          parse("INSERT INTO foo    VALUES ()").should_not be_nil
        end
        
        it "should parse with spaces between the VALUES clause and the list of values" do
          parse("INSERT INTO foo VALUES     ()").should_not be_nil
        end
        
        it "should parse if 'DEFAULT' is used in the VALUE list" do
          parse("INSERT INTO foo VALUES (DEFAULT)").should_not be_nil
        end
        
        it "should parse multiple 'DEFAULT' columns, alonged with mixed columns" do
          parse("INSERT INTO foo VALUES (DEFAULT, DEFAULT)").should_not be_nil
        end
        
        it "should parse DEFAULT(column_name)" do
          parse("INSERT INTO foo VALUES (DEFAULT(col_one))").should_not be_nil
        end
        
        it "should parse DEFAULT(col2)" do
          parse("INSERT INTO foo VALUES (DEFAULT(col_two))").should_not be_nil
        end
        
        it "should parse with spaces between DEFAULT and the parens" do
          parse("INSERT INTO foo VALUES (DEFAULT   (foo))").should_not be_nil
        end
        
        it "should parse with spaces between the DEFAULT opening parens and the column name" do
          parse("INSERT INTO foo VALUES (DEFAULT(     foo))").should_not be_nil
        end
        
        it "should parse with spaces between DEFAULT's column name and the close parens" do
          parse("INSERT INTO foo VALUES (DEFAULT(foo      ))").should_not be_nil
        end
        
        it "should parse with spaces between the VALUES open parens" do
          parse("INSERT INTO foo VALUES (        1)").should_not be_nil
        end
        
        it "should parse with spaces between the VALUES and the close parens" do
          parse("INSERT INTO foo VALUES (1          )").should_not be_nil
        end
        
        it "should parse with no spaces between 'VALUES' and the value list" do
          parse("INSERT INTO foo VALUES()").should_not be_nil
        end
        
        it "should parse if 'VALUE' is used instead of 'VALUES'" do
          parse("INSERT INTO foo VALUE (1)").should_not be_nil
        end
        
        it "should parse without the INTO clause" do
          parse("INSERT foo VALUE(1)").should_not be_nil
        end
        
        it "should parse with the LOW_PRIORITY clause" do
          parse("INSERT LOW_PRIORITY INTO foo VALUES ()").should_not be_nil
        end
        
        it "should parse with the DELAYED clause" do
          parse("INSERT DELAYED INTO foo VALUES ()").should_not be_nil
        end
        
        it "should parse with the HIGH_PRIORITY clause" do
          parse("INSERT HIGH_PRIORITY INTO foo VALUES ()").should_not be_nil
        end
        
        it "should not parse with both the LOW_PRIORITY and the DELAYED clauses" do
          parse("INSERT HIGH_PRIORITY DELAYED INTO foo VALUES ()").should be_nil
        end
        
        it "should parse with the IGNORE clause" do
          parse("INSERT IGNORE foo VALUES (1)").should_not be_nil
        end
        
        it "should parse with a column name after the INSERT clause" do
          parse("INSERT INTO foo (col_one) VALUES (1)").should_not be_nil
        end
        
        it "should parse with a different column name after the INSERT clause" do
          parse("INSERT INTO foo (col_two) VALUES (1)").should_not be_nil
        end
        
        it "should parse with two columns after the INSERT clause" do
          parse("INSERT INTO foo (col_one, col_two) VALUES (1, 2)").should_not be_nil
        end
        
        it "should parse with three columns after the INSERT clause" do
          parse("INSERT INTO foo (col_one, col_two, col_three) VALUES (1, 2)").should_not be_nil
        end
        
        it "should parse with two columns, with no spaces" do
          parse("INSERT INTO foo (col_one,col_two) VALUES (1, 2)").should_not be_nil
        end
        
        it "should parse with two columns, with multiple spaces after the first comma" do
          parse("INSERT INTO foo (col_one,  col_two) VALUES (1, 2)").should_not be_nil
        end
        
        it "should parse with two columns, with multiple spaces after the first col" do
          parse("INSERT INTO foo (col_one   ,col_two) VALUES (1, 2)").should_not be_nil
        end
        
        it "should parse with no spaces between the table name and the open paren" do
          parse("INSERT INTO foo(col_one) VALUES (1)").should_not be_nil
        end
        
        it "should parse with multiple spaces between the table name and the open paren" do
          parse("INSERT INTO foo (    col_one) VALUES (1)").should_not be_nil
        end
        
        it "should parse with multiple spaces between the columns' close parens" do
          parse("INSERT INTO foo ( col_one  ) VALUES (1)").should_not be_nil
        end
        
        it "should not parse if there no space between the table 'VALUES'" do
          parse("INSERT INTO fooVALUES (1)").should be_nil
        end
        
        it "should parse even if the list of values does not match the number of columns" do
          parse("INSERT INTO foo (col_one, col_two) VALUES (1, 3,1231,2342342,323423)").should_not be_nil
        end
        
        it "should parse the insertion of multiple sets of rows"
        
        it "should parse 'ON DUPLICATE KEY UPDATE' key=value"
        
        # And others.  See the spec or http://dev.mysql.com/doc/refman/5.0/en/insert.html
      end
    end
  end
end
