require File.dirname(__FILE__) + "/../../spec_helper"

describe String do
  it "should return itself when calling to_sql" do
    a_string = "foo bar"
    a_string.to_sql.should equal(a_string)
  end
end
