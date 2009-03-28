require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe CreateTable do
      before(:each) do
        @columns = mock 'columns', :empty? => false
      end
      
      it "should have columns" do
        CreateTable.new("foo", @columns).columns.should == @columns
      end
      
      it "should raise an error if the list of columns is empty?" do
        lambda { 
          CreateTable.new("foo", [])
        }.should raise_error(CreateTable::InvalidTableOption, "A table must have one or more columns")
      end
      
      it "should have the table name" do
        tbl = CreateTable.new(:foo, @columns)
        tbl.table_name.should equal(:foo)
      end
      
      it "should have the table name as a sym" do
        tbl = CreateTable.new("foo", @columns)
        tbl.table_name.should equal(:foo)
      end
      
      describe "call" do
        before(:each) do
          @datastore = mock 'datastore'
          @columns = mock 'columns', :empty? => false
        end
        
        it "should call create_table on the datastore" do
          create = CreateTable.new(:foo, @columns)
          @datastore.should_receive(:create_table).with(:foo, :columns => @columns)
          create.call(@datastore)
        end
        
        it "should call create_table in the datastore with the correct table name" do
          create = CreateTable.new(:bar, @columns)
          @datastore.should_receive(:create_table).with(:bar, :columns => @columns)
          create.call(@datastore)
        end
        
        it "should use the default Guillotine::DataStore if none is given" do
          create = CreateTable.new(:foo, @columns)
          Guillotine::DataStore.should_receive(:create_table).with(:foo, :columns => @columns)
          create.call
        end
      end
      
      describe "to_sql" do
        before(:each) do
          @column1 = mock 'column', :to_sql => "SQL_FOR_COL_1"
          @column2 = mock 'column', :to_sql => "SQL_FOR_COL_2"
        end
        
        it "should include 'CREATE TABLE'" do
          tbl = CreateTable.new("foo", [@column1])
          tbl.to_sql.should include("CREATE TABLE")
        end
        
        it "should quote the table name" do
          tbl = CreateTable.new("foo", [@column1])
          tbl.to_sql.should include("`foo`")
        end
        
        it "should use the proper table name" do
          tbl = CreateTable.new("bar", [@column1])
          tbl.to_sql.should include("`bar`")
        end
        
        it "should include one column, wrapped in parens" do
          tbl = CreateTable.new("bar", [@column1])
          tbl.to_sql.should =~ /.*(.*SQL_FOR_COL_1.*).*/
        end
        
        it "should include the sql for the first col" do
          @column1.stub!(:to_sql).and_return "foo"
          
          tbl = CreateTable.new("bar", [@column1])
          tbl.to_sql.should =~ /.*(.*foo.*).*/
        end
        
        it "should include the sql for the second col" do
          tbl = CreateTable.new("bar", [@column1, @column2])
          tbl.to_sql.should =~ /.*SQL_FOR_COL_2.*/
        end
        
        it "should have the columns separated by ',' s" do
          tbl = CreateTable.new("bar", [@column1, @column2])
          tbl.to_sql.should =~ /.*(.*SQL_FOR_COL_1,.*SQL_FOR_COL_2.*).*/m
        end
        
        it "should have the full sql string" do
          tbl = CreateTable.new("bar", [@column1, @column2])
          tbl.to_sql.should == "CREATE TABLE `bar` (\n  SQL_FOR_COL_1,\n  SQL_FOR_COL_2\n)"
        end
      end
      
      describe "==" do
        before(:each) do
          @columns1 = mock "first set of columns", :== => true, :empty? => false
          @columns2 = mock "second set of columns2", :== => true, :empty? => false
        end
        
        it "should be true if it has the columns and the name are ==" do
          creator1 = CreateTable.new("foo", @columns1)
          creator2 = CreateTable.new("foo", @columns2)
          
          creator1.should == creator2
        end
        
        it "should be false if the columns are not ==" do
          creator1 = CreateTable.new("foo", @columns1)
          creator2 = CreateTable.new("foo", @columns2)
          
          @columns1.stub!(:==).and_return false
          
          creator1.should_not == creator2
        end
        
        it "should be false if the table_name is different" do
          creator1 = CreateTable.new("foo", @columns1)
          creator2 = CreateTable.new("bar", @columns2)
          
          creator1.should_not == creator2
        end
        
        it "should be false if it doesn't respond_to? :columns" do
          @comparable = Class.new do
            def table_name
              :foo
            end
          end.new
          
          creator = CreateTable.new("foo", @columns1)
          creator.should_not == @comparable
        end
        
        it "should be false if it doesn't respond_to? :table_name" do
          @comparable = Class.new do
            def columns
              :who_cares
            end
          end.new
          
          creator = CreateTable.new("foo", @columns1)
          creator.should_not == @comparable
        end
      end
    end
  end
end
