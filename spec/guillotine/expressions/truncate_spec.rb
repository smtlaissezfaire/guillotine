require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe Truncate do
      it "should take a table name" do
        Truncate.new("table_name")
      end
      
      it "should have an attribute reader for the table name 'foo'" do
        Truncate.new("foo").table_name.should == :foo
      end
      
      it "should have an attribute reader for the table name 'bar'" do
        Truncate.new("bar").table_name.should == :bar
      end
      
      it "should have a pretty inspect" do
        Truncate.new('baz').inspect.should == "SQL Expression: Truncate table 'baz'"
      end
      
      it "should use the proper table name in the inspect" do
        Truncate.new('foo').inspect.should == "SQL Expression: Truncate table 'foo'"
      end
      
      describe "called with a collection" do
        it "should turn the collection into an empty array" do
          a = [:foo, :bar]
          Truncate.new("foo").call(a)
          a.should == []
        end
        
        it "should return the empty array" do
          Truncate.new("foo").call([:foo, :bar]).should == []
        end
      end
      
      describe "to_sql" do
        it "should be 'TRUNCATE TABLE foo'" do
          Truncate.new(:foo).to_sql.should == "TRUNCATE TABLE foo"
        end
        
        it "should use the table name" do
          Truncate.new(:bar).to_sql.should == "TRUNCATE TABLE bar"          
        end
      end
    end
  end
end
