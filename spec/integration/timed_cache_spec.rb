require File.dirname(__FILE__) + "/../spec_helper"

describe "Creating a cache for 10 minutes" do
  before :each do
    @active_record = ::ActiveRecord::Base
    
    @test_datum = Class.new(@active_record) do
      set_table_name :test_data
    end
    
    @connection = @active_record.connection
  end
  
  it "regression: should have select as a private method before a cache block" do
    @connection.private_methods.should include("select")
  end
  
  it "should have select as a private method after a cache block" do
    guillotine_cache { }
    @connection.class.private_methods.should include("select")
  end
  
  it "regression: should have the method select" do
    guillotine_cache do
      @connection.methods.should include("select")
    end
  end
  
  it "regression: should have the __old_select_aliased_by_guillotine method inside the block" do
    guillotine_cache do
      @connection.methods.should include("__old_select_aliased_by_guillotine__")
    end
  end
  
  it "should cache a row" do
    pending 'todo'
    results = nil
    
    row_one = @test_datum.create(:a_string => "foo")
   
    guillotine_cache do
      results = @test_datum.find(:all)
    end
    
    results.should == [row_one]
  end
  
#   it "should only find a cached result" do
#     pending 'todo'    
    
#     row_one = @test_datum.create(:a_string => "foo")
#     guillotine_cache do
#       row_two = @test_datum.create(:a_string => "bar")
      
#       @test_datum.find(:all).should == [row_one]
#     end
#   end
  
#   it "should actually use a complex sql query" do
#     pending 'todo'
#     row_one = @test_datum.create(:a_string => "foo", :a_number => 10)
#     row_two = @test_datum.create(:a_string => "bar", :a_number => 20)
#     row_three = @test_datum.create(:a_string => "baz", :a_number => 15)
#     row_four = @test_datum.create(:a_string => "fooz", :a_number => 16)
    
#     guillotine_cache do
#       @test_datum.find(:all, :conditions => ["a_number < 18 AND a_number > 11 = ?"], :limit => 1).should == [Object.new]
#     end
#   end
end
