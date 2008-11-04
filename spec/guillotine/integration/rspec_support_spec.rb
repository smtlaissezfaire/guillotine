require File.dirname(__FILE__) + "/spec_helper"

describe "Integration with rspec" do
  before :all do
    Guillotine::RSpec.before_all
  end
  
  before :each do
    Guillotine::RSpec.before_each
    
    @user_class = Class.new(ActiveRecord::Base) do
      set_table_name :users
    end
  end
  
  it "should swap out the db connection" do
    ActiveRecord::Base.connection.private_methods.should include("select_aliased_from_guillotine")
  end
  
  it "should swap out the insert command" do
    ActiveRecord::Base.connection.methods.should include("insert_sql_aliased_from_guillotine")
  end
  
  it "should find a record with sql" do
    user = @user_class.create!(:username => "smtlaissezfaire")
    @user_class.find(:all, :conditions => ["username = ?", "smtlaissezfaire"]).should == [user]
  end
  
  it "should write the record with the same id with which it's found" do
    user = @user_class.create!(:username => "foo")
    potential_user = @user_class.find(:first, :conditions => ["username = ?", "foo"])
    
    user.id.should equal(potential_user.id)
  end
  
  it "should find no records if none are present" do
    @user_class.find(:all).should == []
  end
  
  it "should not find a record if it does not match the conditions" do
    user = @user_class.create!(:username => "smt")
    @user_class.find(:all, :conditions => ["username != ?", "smt"]).should == []
  end
end
