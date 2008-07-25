require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module ActiveRecord
    describe RowSelector do
      describe "selecting" do
        def select(*args)
          RowSelector.new.select(*args)
        end
        
        describe "When something goes wrong..." do
          before :each do
            Guillotine::DataStore.stub!(:table).and_return nil
          end
          
          it "should raise a Guillotine::Exceptions::TableNotTrackedError if the table isn't tracked" do
            lambda { 
              select("SELECT * FROM users")
            }.should raise_error(Guillotine::Exceptions::TableNotTracked, "The users table is not tracked by Guillotine")
          end
          
          it "should raise a Guillotine::Exceptions::TableNotTrackedError if the table isn't tracked, and use the proper the table name" do
            lambda { 
              select("SELECT * FROM foobar")
            }.should raise_error(Guillotine::Exceptions::TableNotTracked, "The foobar table is not tracked by Guillotine")
          end
          
          it "should raise whatever error the parser raises if there is an issue with parsing the expression" do
            lambda { 
              select("SELECT ************ FROM SDFSDFSDFSDFSD SDFWHERWE WHWHWH LIMIT SELECT 100")
            }.should raise_error(Guillotine::Exceptions::SQLNotUnderstood)
          end
        end
        
        describe "When there are no errors" do
          before :each do
            @users_table = [{ :user => :scott }]
            Guillotine::DataStore.stub!(:table).with(:users).and_return @users_table
          end
          
          it "should find the table" do
            Guillotine::DataStore.should_receive(:table).with(:users).and_return @users_table
            select("SELECT * FROM users")
          end
          
          it 'should return the whole table with the results of the query' do
            select("SELECT * FROM users").should == @users_table
          end
          
          it "should execute the sql in the context of the results of the table" do
            select("SELECT * FROM users LIMIT 0").should == []
          end
        end
      end
    end
  end
end
