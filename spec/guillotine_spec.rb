require File.dirname(__FILE__) + "/spec_helper"

describe Guillotine do
  before :each do
    Guillotine::PreParser.stub!(:parse).and_return "pre-processed statement"
    @parsed_content = mock 'parsed content', :eval => nil
    @parser = mock(Guillotine::Parser::SQLParser)
    @parser.stub!(:parse).and_return @parsed_content
    Guillotine.stub!(:sql_parser).and_return @parser
  end
  
  it "should run the pre-processor on the string" do
    Guillotine::PreParser.should_receive(:parse).with("a statement").and_return 'pre-processed statement'
    Guillotine.parse("a statement")
  end
  
  it "should send the pre-processed statement on to the main parser" do
    @parser.should_receive(:parse).with("pre-processed statement").and_return @parsed_content
    Guillotine.parse("a statement")
  end
  
  it "should evaluate the pre-processed statement" do
    @parsed_content.should_receive(:eval).with(no_args)
    Guillotine.parse("a statement")
  end
  
  it "should have RSpec as a top level constant, inside Guillotine" do
    lambda { 
      Guillotine::RSpec
    }.should_not raise_error
  end
  
  it "should have Guillotine::RSpec as an alias for Guillotine::TestSupport::RSpec" do
    Guillotine::RSpec.should equal(Guillotine::TestSupport::RSpec)
  end
  
  it "should call the statement executor's execute method" do
    executor = mock 'executor'
    Guillotine.stub!(:statement_executor).and_return executor
    
    executor.should_receive(:execute).with("SQL STATEMENT")
    Guillotine.execute("SQL STATEMENT")
  end
  
  it "should use the correct sql statement" do
    executor = mock 'executor'
    Guillotine.stub!(:statement_executor).and_return executor
    
    executor.should_receive(:execute).with("SELECT * FROM foo")
    Guillotine.execute("SELECT * FROM foo")
  end
end
