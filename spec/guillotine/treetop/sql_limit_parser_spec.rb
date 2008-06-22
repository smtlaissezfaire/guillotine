require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLLimitParser do
      include ParserSpecHelper
      
      before :each do
        @parser = SQLLimitParser.new
      end
      
      it "should not parse LIMIT" do
        parse("LIMIT").should be_nil
      end
      
      it "should parse LIMIT 10" do
        parse_and_eval("LIMIT 10").should == Expression::Limit.new(10)
      end
      
      it "should parse LIMIT 20" do
        parse_and_eval("LIMIT 20").should == Expression::Limit.new(20)
      end
      
      it "should parse LIMIT  30 (with spaces)" do
        parse_and_eval("LIMIT  30").should == Expression::Limit.new(30)
      end
      
      it "should not parse LIMIT30" do
        parse("LIMIT30").should be_nil
      end
      
      it "should parse LIMIT 0" do
        parse_and_eval("LIMIT 0").should == Expression::Limit.new(0)
      end
      
      it "should not parse LIMIT -1" do
        parse("LIMIT -1").should be_nil
      end
    end
  end
end
