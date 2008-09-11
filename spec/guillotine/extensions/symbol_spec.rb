require File.dirname(__FILE__) + "/../../spec_helper"

describe Symbol do
  it "should return itself as a string when calling to_sql" do
    :foo.to_sql.should == "foo"
  end
end
