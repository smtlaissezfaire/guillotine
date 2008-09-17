require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module TestSupport
    describe Connection do
      before :each do
        @datastore = mock 'connection'
        @connection = Connection.new(@datastore)
        @select_class = mock 'a select class'
        Guillotine.stub!(:execute).and_return @select_class
        @from = mock 'a from clause', :table_name => :foo
        @select_class.stub!(:from).and_return @from
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
        it "should have a select method" do
          @connection.should respond_to(:select)
        end
        
        it "should call Guillotine.execute with the select query given" do
          Guillotine.should_receive(:execute).with("SELECT * FROM users").and_return @select_class
          @connection.select("SELECT * FROM users")
        end
        
        it "should find the table from the from clause in the data store" do
          Guillotine::DataStore.should_receive(:table).with(:foo).and_return []
          @connection.select("SELECT * FROM foo")
        end
      end
    end
  end
end
