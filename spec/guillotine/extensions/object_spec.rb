require File.dirname(__FILE__) + "/../../spec_helper"

describe Object do
  before :each do
    @object = Object.new
    @string = "foo bar baz"
    @unmarshable_object = Class.new { }
  end
  
  it "should have the method object_size" do
    @object.should respond_to(:object_size)
  end
  
  it "should return the size of the marshaled string" do
    @object.object_size.should == Marshal.dump(@object).size
  end
  
  it "should return the size of a different object" do
    @string.object_size.should == Marshal.dump(@string).size
  end
  
  it "should return nil if the size cannot be calculated with Marshal" do
    @unmarshable_object.object_size.should be_nil
  end
end
