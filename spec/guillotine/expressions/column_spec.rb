require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe Column do
      it "should have a column name" do
        Column.new(:bar).column_name.should equal(:bar)
      end
      
      it "should have a nil table name if the table name is inflected" do
        Column.new(:bar).table_name.should be_nil
      end
      
      it "should be able to set the table name" do
        column = Column.new(:bar)
        column.table_name = :baz
        column.table_name.should equal(:baz)
      end
      
      it "should parse the table name when given a combined table / column name" do
        column = Column.new("foo.bar")
        column.table_name.should equal(:foo)
      end
      
      it "should parse the *correct* table_name when given a combined table / column name" do
        column = Column.new("baz.bar")
        column.table_name.should equal(:baz)
      end
       
      it "should parse the column name when given a combined table / column name" do
        column = Column.new("foo.bar")
        column.column_name.should equal(:bar)
      end
      
      it "should find the table name even if the column_name is an interned string" do
        column = Column.new("foo.bar".intern)
        column.table_name.should equal(:foo)
      end
      
      it "should always use a symbol for the column name" do
        column = Column.new("foo")
        column.column_name.should equal(:foo)
      end
      
      describe "to_sql" do
        it "should use the table and column name" do
          Column.new("foo.bar").to_sql.should == "foo.bar"
        end
        
        it "should use the proper table name" do
          Column.new("bar.bar").to_sql.should == "bar.bar"
        end
        
        it "should use the proper column name" do
          Column.new("bar.fnord").to_sql.should == "bar.fnord"
        end
        
        it "should use an ambiguous column name if no table is present" do
          Column.new(:foo).to_sql.should == "foo"
        end
      end
    end
  end
end
