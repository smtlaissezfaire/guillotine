require File.dirname(__FILE__) + "/spec_helper"

describe "Integration with rspec" do
  before :all do
    Guillotine::RSpec.before_all
  end
  
  before :each do
    Guillotine::RSpec.before_each
  end
  
  it "should swap out the db connection" do
    ActiveRecord::Base.connection.private_methods.should include("select_aliased_from_guillotine")
  end
  
  it "should swap out the insert command" do
    ActiveRecord::Base.connection.methods.should include("insert_sql_aliased_from_guillotine")
  end
  
  it "should find a record with sql" do
    pending 'TODO: Intercept other calls to adapter, namely INSERT, UPDATE, and DELETE'
    user_class = Class.new(ActiveRecord::Base) do
      set_table_name :users
    end
    
    first_user = user_class.create!(:username => "smtlaissezfaire")
    user_class.find(:all).should == [first_user]
  end
end
