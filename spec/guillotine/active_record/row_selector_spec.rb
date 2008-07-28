require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module ActiveRecord
    describe RowSelector do
      before :each do
        @row_selector = RowSelector.new
        @connection = mock 'ar connection', :__old_select_aliased_by_guillotine__ => nil
        ::ActiveRecord::Base.stub!(:connection).and_return @connection
        
        @table = mock 'in memory table', :empty? => true
      end
      
      describe "selecting" do
        def select(*args)
          @row_selector.select(*args)
        end
        
        describe "When something goes wrong..." do
          before :each do
            Guillotine::DataStore.stub!(:table).and_return nil
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
        
        describe "on the first fetch" do
          before :each do
            Guillotine::DataStore.stub!(:initial_insert).and_return []
          end
          
          it "should find all of the records for the table 'users'" do
            @connection.stub!(:__old_select_aliased_by_guillotine__).and_return([])
            @connection.should_receive(:__old_select_aliased_by_guillotine__).with("SELECT * FROM users").and_return []
            select("SELECT * FROM users")
          end
          
          it "should store the results of finding the records in the in memory table" do
            @connection.stub!(:__old_select_aliased_by_guillotine__).and_return([{ :foo => :bar}])
            Guillotine::DataStore.should_receive(:initial_insert).with(:users, [{ :foo => :bar }])
            select("SELECT * FROM users")
          end
          
          it "should find the records with the correct table name" do
            @connection.stub!(:__old_select_aliased_by_guillotine__).and_return([])
            @connection.should_receive(:__old_select_aliased_by_guillotine__).with("SELECT * FROM table_data").and_return []
            select("SELECT * FROM table_data LIMIT 10")
          end
          
          it "should store the results of finding the records in the in memory table" do
            @connection.stub!(:__old_select_aliased_by_guillotine__).and_return([{ :foo => :bar}])
            Guillotine::DataStore.should_receive(:initial_insert).with(:table_data, [{ :foo => :bar }])
            select("SELECT * FROM table_data")
          end
          
          it "should create the table if it doesn't exist" do
            Guillotine::DataStore.should_receive(:create_table).with(:users)
            select("SELECT * FROM users")
          end
          
          it "should create the table if it doesn't exist (with the proper name)" do
            Guillotine::DataStore.should_receive(:create_table).with(:table_data)
            select("SELECT * FROM table_data WHERE foo='bar'")
          end
          
        end
        
        describe "on second fetch" do
          before :each do
            Guillotine::DataStore.stub!(:tables).and_return [:users, :test_data]
          end
          
          it "should find the table" do
            Guillotine::DataStore.should_receive(:table).with(:users).and_return @table
            select("SELECT * FROM users")
          end
          
          it "should find the table with the correct name" do
            Guillotine::DataStore.should_receive(:table).with(:test_data).and_return @table
            select("SELECT * FROM test_data")
          end
        end
      end
    end
  end
end
