require File.dirname(__FILE__) + "/../spec_helper"

describe Object do
  it "should not have the ::Test constant defined" do
    defined?(::Test).should be_nil
  end
end
