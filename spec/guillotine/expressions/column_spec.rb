require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe Column do
      
      it "should have a table name" do
        Column.new(:foo, :bar).table_name.should equal(:foo)
      end
      
      it "should have a column name" do
        Column.new(:foo, :bar).column_name.should equal(:bar)
      end
      
      describe "to_sql" do
        it "should use the table and column name" do
          Column.new(:foo, :bar).to_sql.should == "foo.bar"
        end
        
        it "should use the proper table name" do
          Column.new(:bar, :bar).to_sql.should == "bar.bar"
        end
        
        it "should use the proper column name" do
          Column.new(:bar, :fnord).to_sql.should == "bar.fnord"
        end
      end
    end
  end
end
