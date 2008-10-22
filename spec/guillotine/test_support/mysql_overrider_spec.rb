require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module TestSupport
    describe MysqlOverrider do
      before :each do
        @db_connection = Class.new do
          def insert_sql(sql, name = nil, pk = nil, id_value = nil, sequence_name = nil) #:nodoc:
            :regular_insert
          end
        private
          def select(sql_query)
            :regular_select
          end
        end.new

        @guillotine_connection = mock 'guillotine connection', :insert_sql => nil
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
        @db_connection.select("a string").should equal(:guillotine_result)
      end
      
      it "should return the real result from guillotine" do
        @adapter.stub!(:select_from_guillotine).and_return :a_different_guillotine_result
        @db_connection.select("a string").should equal(:a_different_guillotine_result)
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
          @guillotine_connection.should_receive(:select).with("SELECT * FROM users").and_return [{ :foo => "bar" }]
          @adapter.select_from_guillotine("SELECT * FROM users")
        end
        
        it "should call it with the correct string" do
          @guillotine_connection.should_receive(:select).with("SELECT * FROM people").and_return [{ :foo => "bar" }]
          @adapter.select_from_guillotine("SELECT * FROM people")
        end
        
        it "should stringify the hash returned from the select method" do
          @guillotine_connection.stub!(:select).with("SELECT * FROM people").and_return([{ :foo => "bar" }])
          @adapter.select_from_guillotine("SELECT * FROM people").should == [{ "foo" => "bar" }]
        end
      end
      
      describe "insert_sql_from_guillotine" do
        it "should have the method insert_sql_from_guillotine" do
          MysqlOverrider.instance_methods.should include("insert_sql_from_guillotine")
        end
        
        it "should call the connections old insert method" do
          insert_string = "INSERT INTO table (col1) VALUES (1)"
          @db_connection.should_receive(:insert_sql_aliased_from_guillotine).with(insert_string)
          @adapter.insert_sql_from_guillotine(insert_string)
        end
        
        it "should return the connections old insert method return value" do
          a_return_value = "foobarbaz"
          
          insert_string = "INSERT INTO table (col1) VALUES (1)"
          @db_connection.should_receive(:insert_sql_aliased_from_guillotine).with(insert_string).and_return a_return_value
          @adapter.insert_sql_from_guillotine(insert_string).should == a_return_value
        end
        
        it "should insert the records the records through the connection" do
          insert_string = "INSERT INTO table (col1) VALUES (1)"
          @guillotine_connection.should_receive(:insert_sql).with(insert_string)
          @adapter.insert_sql_from_guillotine(insert_string)
        end
      end
    end
  end
end
