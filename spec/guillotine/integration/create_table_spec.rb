require File.dirname(__FILE__) + "/../../spec_helper"

describe "Datastore / Create table Integration" do
  it "should create the table in the datastore" do
    Guillotine.parse("CREATE TABLE foo (id INT (11))").call
    Guillotine::DataStore.table_names.should include(:foo)
  end
  
  it "should be able to show the table" do
    Kernel.stub!(:puts).and_return nil
    lambda { 
      Guillotine::Shell::Command.execute("CREATE TABLE foo (id BIT)")
      Guillotine::Shell::Command.execute("SHOW TABLES")
    }.should_not raise_error
  end
end
