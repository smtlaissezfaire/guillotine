require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module TestSupport
    describe Connection do
      before :each do
        @datastore = mock 'connection'
        @connection = Connection.new(@datastore)
      end
      
      it "should truncate all the tables in the datastore on rollback" do
        @datastore.should_receive(:truncate_all_tables)
        @connection.rollback!
      end
      
      it "should have the datastore" do
        @connection.datastore.should == @datastore
      end
      
      it "should default to the Guillotine::Datastore" do
        Connection.new.datastore.should == Guillotine::DataStore
      end
    end
  end
end
