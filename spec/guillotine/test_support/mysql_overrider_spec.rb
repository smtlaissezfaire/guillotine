require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module TestSupport
    describe MysqlOverrider do
      before :each do
        @db_connection = Class.new do
        private
          def select(sql_query)
            :regular_select
          end
        end.new

        @guillotine_connection = mock 'guillotine connection'
        @adapter = MysqlOverrider.new(@db_connection, @guillotine_connection)
      end
      
      it "should have the database connection" do
        @adapter.db_connection.should == @db_connection
      end
      
      it "should have the guillotine connection" do
        @adapter.guillotine_connection.should == @guillotine_connection
      end
      
      it "should store away the regular select, and alias it as select_aliased_from_guillotine" do
        @db_connection.send(:select_aliased_from_guillotine, "a string").should == :regular_select
      end
      
      it "should redefine select to proxy the adapter" do
        @adapter.stub!(:select_from_guillotine).and_return :guillotine_result
        @db_connection.send(:select, "a string").should == :guillotine_result
      end
      
      it "should return the real result from guillotine" do
        @adapter.stub!(:select_from_guillotine).and_return :a_different_guillotine_result
        @db_connection.send(:select, "a string").should == :a_different_guillotine_result
      end
      
      describe "select_from_db" do
        it "should call the connection's select method" do
          @db_connection.should_receive(:select_aliased_from_guillotine).with("SELECT * FROM users", nil)
          @adapter.select_from_db("SELECT * FROM users")
        end
        
        it "should call it with the correct string" do
          @db_connection.should_receive(:select_aliased_from_guillotine).with("SELECT * FROM people", nil)
          @adapter.select_from_db("SELECT * FROM people")
        end
      end
      
      describe "select_from_guillotine" do
        it "should call the connection's select method" do
          @guillotine_connection.should_receive(:select).with("SELECT * FROM users")
          @adapter.select_from_guillotine("SELECT * FROM users")
        end
        
        it "should call it with the correct string" do
          @guillotine_connection.should_receive(:select).with("SELECT * FROM people")
          @adapter.select_from_guillotine("SELECT * FROM people")
        end
        
        it "should call the db connection if there is an error" do
          @guillotine_connection.stub!(:select).and_raise
          @db_connection.should_receive(:select_aliased_from_guillotine).with("SELECT * FROM users", nil)
          @adapter.select_from_guillotine("SELECT * FROM users")
        end
      end
    end
  end
end
