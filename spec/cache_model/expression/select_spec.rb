require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  describe SelectExpression do
    it "should have the query string" do
      SelectExpression.new(:string => "foo bar").query_string.should == "foo bar"
    end
    
    it "should have the proper query string" do
      SelectExpression.new(:string => "SELECT * FROM events").query_string.should == "SELECT * FROM events"
    end
    
    it "should have a pretty inspect" do
      query = "SELECT * FROM events"
      expr = SelectExpression.new(:string => query)
      expr.inspect.should == "Guillotine::SelectExpression: SELECT * FROM events"
    end
  end
end
