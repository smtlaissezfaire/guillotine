require File.dirname(__FILE__) + "/../../spec_helper"

describe Fixnum do
  it "should return itself as a string when calling to_sql" do
    17.to_sql.should == "17"
  end
end
