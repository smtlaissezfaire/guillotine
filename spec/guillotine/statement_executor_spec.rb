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
    
    describe "execute" do
      before(:each) do
        @result = mock 'Intermediate Representation', :call => "some result"
        @executor.stub!(:parse).and_return @result
      end
      
      it "should call parse with an argument" do
        @executor.should_receive(:parse).with("FOO").and_return @result
        @executor.execute("FOO")
      end
      
      it "should call the call method on the IR" do
        @result.should_receive(:call).with(no_args).and_return "some text"
        @executor.execute("FOO")
      end
      
      it "should call parse with the string passed to it" do
        @executor.should_receive(:parse).with("BAR").and_return @result
        @executor.execute("BAR")
      end
    end
  end
end
