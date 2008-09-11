require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe Limit do
      describe "to_sql" do
        it "should return 'LIMIT 10'" do
          Limit.new(10).to_sql.should == "LIMIT 10"
        end
        
        it "should use the proper limit number" do
          Limit.new(25).to_sql.should == "LIMIT 25"
        end
      end
    end
  end
end
