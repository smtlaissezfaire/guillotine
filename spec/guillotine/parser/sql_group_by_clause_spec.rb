require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLGroupByClauseParser do
      include ParserSpecHelper

      before :each do
        @parser = SQLGroupByClauseParser.new
      end
      
      it "should parse GROUP BY foo" do
        parse("GROUP BY foo").should_not be_nil
      end
      
      it "should not parse GROUP BY with no predicate" do
        parse("GROUP BY").should be_nil
      end
      
      it "should parse two columns, with commas between the columns" do
        parse("GROUP BY foo, bar").should_not be_nil
      end
    end
  end
end
