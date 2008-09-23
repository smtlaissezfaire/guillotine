require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe Insert do
      it "should have a table name to insert into" do
        insert = Insert.new
        insert.into = :a_table
        insert.into.should equal(:a_table)
      end
      
      it "should allow the table in the init" do
        insert = Insert.new(:into => :a_table)
        insert.into.should == :a_table
      end
      
      it "should have a list of columns" do
        insert = Insert.new
        insert.columns = [:foo, :bar]
        insert.columns.should == [:foo, :bar]
      end
      
      it "should allow the columns in the init" do
        Insert.new(:columns => [:foo, :bar]).columns.should == [:foo, :bar]
      end
      
      it "should raise an error if an unknown key is given in the init" do
        lambda { 
          Insert.new(:foo => [:bar])
        }.should raise_error(Insert::UnknownInsertExpression, "foo is not a valid insert key")
      end
      
      it "should have a list of values" do
        insert = Insert.new
        insert.values = ["foo", "bar"]
        insert.values.should == ["foo", "bar"]
      end
      
      describe "to_sql" do
        it "should return the correct string with an into and values clause" do
          insert = Insert.new(:into => :foo, :values => [1,2,3])
          insert.to_sql.should == "INSERT INTO foo VALUES (1, 2, 3)"
        end
        
        it "should use the correct table name" do
          insert = Insert.new(:into => :bar, :values => [1,2,3])
          insert.to_sql.should == "INSERT INTO bar VALUES (1, 2, 3)"
        end
        
        it "should use the correct values" do
          insert = Insert.new(:into => :bar, :values => [3,2,1])
          insert.to_sql.should == "INSERT INTO bar VALUES (3, 2, 1)"
        end
        
        it "should properly escape a string value" do
          insert = Insert.new(:into => :users, :values => ["Scott"])
          insert.to_sql.should == "INSERT INTO users VALUES (\"Scott\")"
        end
        
        it "should use a column if specified" do
          insert = Insert.new(:into => :users, :columns => [:username], :values => ["Scott"])
          insert.to_sql.should == "INSERT INTO users (username) VALUES (\"Scott\")"
        end
        
        it "should allow multiple columns" do
          insert = Insert.new(:into => :users, :columns => [:num_one, :num_two], :values => [1, 2])
          insert.to_sql.should == "INSERT INTO users (num_one, num_two) VALUES (1, 2)"
        end
      end
    end
  end
end
