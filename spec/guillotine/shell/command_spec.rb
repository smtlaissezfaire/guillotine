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
        
        describe "debug" do
          before(:each) do
            @command = Command.new("debug")
            @command.stub!(:require)
            @command.stub!(:debugger)
          end
          
          it "should require ruby-debug" do
            @command.should_receive(:require).with("ruby-debug").and_return nil
            @command.execute
          end
          
          it "should invoke the debugger" do
            @command.should_receive(:debugger).with(no_args).and_return nil
            @command.execute
          end
        end
        
        describe "debug with a command" do
          before(:each) do
            @command = Command.new("debug SELECT * FROM foo")
            @command.stub!(:require)
            @command.stub!(:debugger)
          end
          
          it "should require ruby-debug" do
            @command.should_receive(:require).with("ruby-debug").and_return nil
            @command.execute
          end
          
          it "should invoke the debugger" do
            @command.should_receive(:debugger).with(no_args).and_return nil
            @command.execute
          end
        end
        
        describe "a command that does not start with debug" do
          def stub_debugger(command)
            command.stub!(:require)
            command.stub!(:debugger)
          end
          
          it "should call Guillotine.execute with the string otherwise" do
            command = Command.new("debug foo")
            stub_debugger(command)
            
            Guillotine.should_receive(:execute).with("foo").and_return "something"
            command.execute
          end
          
          it "should call Guillotine.execute with the *same* command" do
            command = Command.new("debug bar")
            stub_debugger(command)            
            
            Guillotine.should_receive(:execute).with("bar").and_return "something"
            command.execute
          end
          
          it "should wrap the execution results in an OutputFormatter" do
            command = Command.new("debug bar")
            stub_debugger(command)
            
            results = mock('a mock')
            Guillotine.stub!(:execute).and_return(results)
            
            OutputFormatter.should_receive(:format).with(results)
            command.execute
          end
        end
        
        describe "debug statement in incorrect format" do
          before(:each) do
            Guillotine.stub!(:execute).and_return "foo"
            OutputFormatter.stub!(:format).and_return "some text"
          end
          
          def stub_debugger(command)
            command.stub!(:require)
            command.stub!(:debugger)
          end
          
          it "should not start the debugger if it has debug in the middle of the sequence" do
            command = Command.new("foo debug foo")
            stub_debugger(command)
            
            command.should_not_receive(:debugger)
            command.execute
          end
          
          it "should not start the debugger if does not start with a coherent 'debug'" do
            command = Command.new("debugfoo")
            stub_debugger(command)
            
            command.should_not_receive(:debugger)
            command.execute
          end
        end
        
        describe "if not receiving a debug sequence or exit sequence" do
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
