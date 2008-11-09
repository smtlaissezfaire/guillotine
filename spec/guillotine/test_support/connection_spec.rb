require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module TestSupport
    describe Connection do
      before :each do
        @datastore = mock 'datastore', :table => []
        @connection = Connection.new(@datastore)
      end
      
      it "should truncate all the tables in the datastore on rollback" do
        @datastore.should_receive(:truncate_all_tables!)
        @connection.rollback!
      end
      
      it "should have the datastore" do
        @connection.datastore.should == @datastore
      end
      
      it "should default to the Guillotine::Datastore" do
        Connection.new.datastore.should == Guillotine::DataStore
      end
      
      describe "select" do
        before :each do
          @select = mock 'a select', :call => nil
          Guillotine.stub!(:parse).and_return @select
          @from = mock 'a from clause', :table_name => :foo
          @select.stub!(:from).and_return @from
        end
        
        it "should have a select method" do
          @connection.should respond_to(:select)
        end
        
        it "should call Guillotine.parse with the select query given" do
          Guillotine.should_receive(:parse).with("SELECT * FROM users").and_return @select
          @connection.select("SELECT * FROM users")
        end
        
        it "should find the table from the from clause in the data store" do
          @datastore.should_receive(:table).with(:foo).and_return []
          @connection.select("SELECT * FROM foo")
        end
        
        it "should call the select statement with the table name of the collection" do
          a_collection = mock 'foo table collection'
          @datastore.stub!(:table).and_return a_collection
          @select.should_receive(:call).with(a_collection)
          @connection.select("SELECT * FROM foo")
        end
      end
      
      describe "insert_sql" do
        before :each do
          @insert = mock 'insert', :call => true, :into => :foo
          Guillotine.stub!(:parse).and_return @insert
          @collection = mock 'a collection'
          
          @datastore.stub!(:table).and_return @collection
        end
        
        it "should have the method" do
          @connection.should respond_to(:insert_sql)
        end
        
        it "should call Guillotine.parse with the insert query" do
          Guillotine.should_receive(:parse).with(@insert_query).and_return @insert
          @connection.insert_sql(@insert_sql)
        end
        
        it "should insert the row into the datastore" do
          @insert.should_receive(:call).and_return true
          @connection.insert_sql(@insert_sql)
        end
        
        it "should find the table from the from clause in the data store" do
          @insert.stub!(:into).and_return :foo
          @datastore.should_receive(:table).with(:foo).and_return @collection
          @connection.insert_sql("INSERT INTO foo VALUES (1)")
        end
        
        it "should call it with the collection received by looking it up in the datastore" do
          @datastore.stub!(:table).and_return @collection
          @insert.should_receive(:call).with(@collection)
          
          @connection.insert_sql("INSET INTO foo VALUES (1)")
        end
      end
    end
  end
end
