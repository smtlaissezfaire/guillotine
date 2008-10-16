require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module DataStore
    describe Table do
      it "should be a kind_of? Array" do
        Table.new(:foo).should be_a_kind_of(Array)
      end
      
      it "should initialize with a table name" do
        Table.new(:foo).table_name.should == :foo
      end
      
      it "should use the correct table name" do
        Table.new(:bar).table_name.should == :bar
      end
      
      it "should symbolize a table name given as a string" do
        Table.new("foo").table_name.should == :foo
      end
      
      it "should take a schema options, and return them back" do
        schema_options = { :auto_increment => true, :primary_key => :id }
        tbl = Table.new(:users, schema_options)
        tbl.schema_options.should == schema_options
      end
      
      it "should have an empty hash of schema options if none are provided" do
        Table.new(:foo).schema_options.should == { }
      end
      
      it "should take an optional list of rows as it's third parameter, and treat those rows as an array normally does" do
        tbl = Table.new(:foo, { }, [:row1, :row2])
        tbl << :row3
        tbl.to_a.should == [:row1, :row2, :row3]
      end
      
      it "should have an empty array of rows when none are given" do
        tbl = Table.new(:foo, { })
        tbl.to_a.should == []
        tbl.should be_empty
      end
    end
  end
end
