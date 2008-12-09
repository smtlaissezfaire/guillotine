require File.dirname(__FILE__) + "/spec_helper"

describe Guillotine do
  it "should have RSpec as a top level constant, inside Guillotine" do
    lambda { 
      Guillotine::RSpec
    }.should_not raise_error
  end
  
  it "should have Guillotine::RSpec as an alias for Guillotine::TestSupport::RSpec" do
    Guillotine::RSpec.should equal(Guillotine::TestSupport::RSpec)
  end

  def executor_class
    Guillotine::StatementExecutors::MultiExecutor
  end
  
  describe "execute" do
    before(:each) do
      @executor = mock 'executor', :execute => "foo"
      executor_class.stub!(:new).and_return @executor
    end
    
    it "should instantiate a new executor" do
      executor_class.should_receive(:new).with("a string").and_return @executor
      Guillotine.execute("a string")
    end
    
    it "should call execute on the string" do
      @executor.should_receive(:execute).and_return "some results"
      Guillotine.execute("foo")
    end
  end
  
  describe "parse" do
    before(:each) do
      @executor = mock 'executor', :parse => "foo"
      executor_class.stub!(:new).and_return @executor
    end
    
    it "should instantiate a new executor" do
      executor_class.should_receive(:new).with("a string").and_return @executor
      Guillotine.parse("a string")
    end
    
    it "should call parse on the string" do
      @executor.should_receive(:parse).and_return "some results"
      Guillotine.parse("foo")
    end
  end
end
