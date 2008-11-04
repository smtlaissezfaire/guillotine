require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Shell
    describe Command do
      before(:each) do
        Kernel.stub!(:exit).and_return nil
        Guillotine.stub!(:execute).and_return "something"
        OutputFormatter.stub!(:format).and_return "something"
      end
      
      describe "executing a command" do
        it "should exit when given the input 'exit'" do
          command = Command.new("exit")
          Kernel.should_receive(:exit)
          command.execute
        end
        
        it "should call Guillotine.execute with the string otherwise" do
          command = Command.new("foo")
          Guillotine.should_receive(:execute).with("foo").and_return "something"
          command.execute
        end
        
        it "should call Guillotine.execute with the *same* command" do
          command = Command.new("bar")
          Guillotine.should_receive(:execute).with("bar").and_return "something"
          command.execute
        end
        
        it "should wrap the execution results in an OutputFormatter" do
          command = Command.new("bar")
          results = mock('a mock')
          Guillotine.stub!(:execute).and_return(results)
          
          OutputFormatter.should_receive(:format).with(results)
          command.execute
        end
      end
      
      describe "the class method execute" do
        before(:each) do
          @command = mock 'command', :execute => "output"
          Command.stub!(:new).and_return @command
        end
        
        it "should instantiate a new instance" do
          Command.should_receive(:new).and_return @command
          Command.execute(:foo)
        end
        
        it "should instantiate a new instance with the command given" do
          Command.should_receive(:new).with("foo").and_return @command
          Command.execute("foo")
        end
        
        it "should instantiate a new instance with the correct command" do
          Command.should_receive(:new).with("bar").and_return @command
          Command.execute("bar")
        end
        
        it "should call execute" do
          @command.should_receive(:execute)
          Command.execute("foo")
        end
      end
    end
  end
end
