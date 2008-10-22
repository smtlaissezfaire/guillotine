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
      
      describe "with auto-increment => true" do
        describe "with the primary key 'id'" do
          before(:each) do
            @table = Table.new(:foo, :auto_increment => true, :primary_key => :id)
          end
          
          it "should add an id field to the elemnt being inserted" do
            record = { :foo => :bar }
            @table << record
            @table.to_a.first.keys.should include(:id)
          end
          
          it "should add the id with value of '1' to the first element inserted" do
            record = { :foo => :bar }
            @table << record
            @table.to_a.should == [{ :foo => :bar, :id => 1 }]
          end
          
          it "should add the id with the value of '2' to the second element inserted" do
            record = { :foo => :bar }
            @table << { }
            @table << record
            @table.to_a.should include({ :foo => :bar, :id => 2 })
          end
        end
        
        describe "with the primary key :foo_bar_id" do
          before(:each) do
            @table = Table.new(:foo, :auto_increment => true, :primary_key => :foo_bar_id)
          end
          
          it "should add the id with value of '1' to the first element inserted" do
            record = { :foo => :bar }
            @table << record
            @table.to_a.should == [{ :foo => :bar, :foo_bar_id => 1 }]
          end
        end
        
        describe "when there is no primary key, but there is an auto-increment" do
          it 'should raise when initializing' do
            lambda { 
              Table.new(:foo, :auto_increment => true)
            }.should raise_error(Guillotine::DataStore::Table::PrimaryKeyError, "A Primary Key must be specified with auto-increment => true")
          end
        end
      end
      
      describe "a non-auto-incrementing table", :shared => true do
        it "should add a record without adding an :id field" do
          record = { :foo => :bar }
          @table << record
          @table.to_a.should == [record]
        end
        
        it "should allow a record with id field to be added" do
          record = { :id => 7 }
          @table << record
          @table.to_a.should == [record]
        end
      end
      
      describe "when auto_increment => false" do
        before(:each) do
          @table = Table.new(:foo, :auto_increment => false)
        end
        
        it_should_behave_like "a non-auto-incrementing table"
      end
      
      describe "when no auto_increment option is given" do
        before(:each) do
          @table = Table.new(:foo)
        end

        it_should_behave_like "a non-auto-incrementing table"
      end
    end
  end
end