require File.dirname(__FILE__) + "/spec_helper"

describe "Integration with rspec" do
  before :all do
    Guillotine::RSpec.before_all
  end
  
  before :each do
    Guillotine::RSpec.before_each
  end
  
  it "should find swap out the db connection" do
    ActiveRecord::Base.connection.should respond_to(:select_aliased_from_guillotine)
  end
end
