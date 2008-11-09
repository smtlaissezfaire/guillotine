require File.dirname(__FILE__) + "/../../spec_helper"

describe "Datastore / Create table Integration" do
  before(:each) do
    Guillotine::DataStore.__clear_all_tables!
  end
  
  it "should create the table in the datastore" do
    Guillotine.execute("CREATE TABLE foo (id INT (11))").call
    Guillotine::DataStore.table_names.should include(:foo)
  end
end
