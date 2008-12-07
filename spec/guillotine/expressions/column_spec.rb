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
      
      describe "==" do
        it "should be equal if one has a table name, and one doesn't (with the same columns)" do
          col1 = Column.new("foo.bar")
          col2 = Column.new("bar")
          col1.should == col2
          col2.should == col1
        end
        
        it "should not be equal with different table names" do
          col1 = Column.new("bar.baz")
          col2 = Column.new("foo.baz")
          col1.should_not == col2
          col2.should_not == col1
        end
        
        it "should not be equal with different column names" do
          col1 = Column.new("foo.bar")
          col2 = Column.new("foo.baz")
          col1.should_not == col2
          col2.should_not == col1
        end
        
        it "should be equal with the same table and column name" do
          col1 = Column.new("foo.bar")
          col2 = Column.new("foo.bar")
          col1.should == col2
          col2.should == col1
        end
        
        it "should be equal if both have the same column name with no table" do
          col1 = Column.new("bar")
          col2 = Column.new("bar")
          col1.should == col2
          col2.should == col1
        end
        
        it "should not be equal if the two have different same column names with no table" do
          col1 = Column.new("baz")
          col2 = Column.new("bar")
          col1.should_not == col2
          col2.should_not == col1
        end
      end
      
      describe "eql?" do
        it "should NOT be equal if one has a table name, and one doesn't (with the same columns)" do
          col1 = Column.new("foo.bar")
          col2 = Column.new("bar")
          col1.should_not eql(col2)
          col2.should_not eql(col1)
        end
        
        it "should not be equal with different table names" do
          col1 = Column.new("bar.baz")
          col2 = Column.new("foo.baz")
          col1.should_not eql(col2)
          col2.should_not eql(col1)
        end
        
        it "should not be equal with different column names" do
          col1 = Column.new("foo.bar")
          col2 = Column.new("foo.baz")
          col1.should_not eql(col2)
          col2.should_not eql(col1)
        end
        
        it "should be equal with the same table and column name" do
          col1 = Column.new("foo.bar")
          col2 = Column.new("foo.bar")
          col1.should eql(col2)
          col2.should eql(col1)
        end
        
        it "should NOT be equal if both have the same column name with no table" do
          col1 = Column.new("bar")
          col2 = Column.new("bar")
          col1.should_not equal(col2)
          col2.should_not equal(col1)
        end
        
        it "should not be equal if the two have different same column names with no table" do
          col1 = Column.new("baz")
          col2 = Column.new("bar")
          col1.should_not equal(col2)
          col2.should_not equal(col1)
        end
      end
      
      describe "lowercasing column names" do
        it "should lowercase the column name" do
          col = Column.new("FOO")
          col.column_name.should == :foo
        end
        
        it "should lowcase the column name if given with a table name" do
          col = Column.new("FOO.BAR")
          col.column_name.should == :bar
        end
      end

      describe "primary_key" do
        before(:each) do
          @col = Column.new("foo")
        end

        it "should not be a primary key by default" do
          @col.should_not be_a_primary_key
        end

        it "should return *false* when it's not a primary key" do
          @col.primary_key?.should be_false
        end

        it "should be setable to true" do
          @col.primary_key = true
          @col.primary_key?.should be_true
        end
      end
    end
  end
end
