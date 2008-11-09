require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe StatementExecutor do
    before(:each) do
      @parser = mock 'parser'
      @pre_parser = mock 'pre parser'
      @executor = StatementExecutor.new(@pre_parser, @parser)
    end
    
    describe "with invalid sql" do
      before(:each) do
        @pre_parser.stub!(:parse).and_return "some sql"
        @parser.stub!(:parse).and_return nil
      end
      
      it "should raise a Guillotine::SQLParseError if it cannot parse the query with the parser" do
        lambda { 
          @executor.parse("some sql")
        }.should raise_error(Guillotine::SQLParseError)
      end
      
      it "should include the query in the error" do
        lambda { 
          @executor.parse("some sql")
        }.should raise_error(Guillotine::SQLParseError, "Could not parse query: some sql")
      end
    end
  end
end
