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
        schema_options = { :columns => [mock('column')] }
        tbl = Table.new(:users, schema_options)
        tbl.schema_options.should == schema_options
      end
      
      it "should have an empty hash of schema options if none are provided" do
        Table.new(:foo).schema_options.should == { }
      end
      
      it "should take an optional list of rows as it's third parameter, and treat those rows as an array normally does" do
        @row1 = { :id => 1 }
        @row2 = { :id => 2 }
        
        tbl = Table.new(:foo, { }, [@row1])
        tbl << @row2
        tbl.to_a.should == [{ :id => 1 }, { :id => 2}]
      end
      
      it "should have an empty array of rows when none are given" do
        tbl = Table.new(:foo, { })
        tbl.to_a.should == []
        tbl.should be_empty
      end

      describe "when given no column information" do
        before(:each) do
          @table = Table.new(:foo)
        end

        it "should assume auto-increment true" do
          @table.should be_auto_incrementing
        end

        it "should use the primary key of 'id'" do
          @table.primary_key.should == :id
        end
      end

      describe "when given columns, but no primary key" do
        before(:each) do
          column = mock('a column', :primary_key? => false)
          @table = Table.new(:foo, :columns => [column])
        end
        
        it "should have auto_increment as false" do
          @table.should_not be_auto_incrementing
        end

        it "should have the primary key as nil" do
          @table.primary_key.should be_nil
        end
      end

      describe "when given a column with a primary key" do
        before(:each) do
          @col = mock 'a column', :column_name => :foo, :primary_key? => true
          @table = Table.new(:foo, :columns => [@col])
        end

        it "should have the primary key id" do
          @table.primary_key.should equal(:foo)
        end

        it "should return the correct primary key id" do
          @col.stub!(:column_name).and_return :bar
          @table.primary_key.should equal(:bar)
        end

        it "should return the second column, if the second column has the primary key" do
          col_one = mock 'a column', :column_name => :foo, :primary_key? => false
          col_two = mock 'a column', :column_name => :bar, :primary_key? => true
          
          table = Table.new(:foo, :columns => [col_one, col_two])
          table.primary_key.should equal(:bar)
        end

        it "should raise an error if there is more than one primary key"
      end

      describe "auto-increment" do
        before(:each) do
          @column = mock 'column', :primary_key? => true
          @table = Table.new(:foo, :columns => [@column])
        end

        it "should be false if the primary key doesn't support auto-increment" do
          @column.stub!(:auto_increment?).and_return false
          @table.auto_increment?.should be_false
        end

        it "should be true if the primary key *does* support auto_increment?" do
          @column.stub!(:auto_increment?).and_return true
          @table.auto_increment?.should be_true
        end
      end
      
      describe "truncate" do
        before(:each) do
          @table = Table.new(:foo, :auto_increment => true, :primary_key => :id)
          @table << { :foo => :bar }
        end
        
        it "should clear the data" do
          @table.truncate
          @table.should be_empty
        end
        
        it "should reset the auto_increment id" do
          @table.truncate
          @table << { :foo => :bar }
          @table.should == [{ :foo => :bar, :id => 1}]
        end
      end
    end
  end
end
