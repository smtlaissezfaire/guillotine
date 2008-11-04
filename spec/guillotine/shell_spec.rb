require File.dirname(__FILE__) + "/../spec_helper"

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
    
    describe "Main" do
      before(:each) do
        Main.stub!(:loop).and_yield
        Kernel.stub!(:puts)
        Kernel.stub!(:printf)
        STDIN.stub!(:read).and_return "STDIN"
        Command.stub!(:execute).and_return "some output"
      end
      
      describe "do" do
        it "should have some introductory text" do
          Main::INTRODUCTORY_TEXT.should =~ /Welcome to Guillotine SQL/m
        end
        
        it "should output the introduction text" do
          Kernel.should_receive(:puts).with(Main::INTRODUCTORY_TEXT)
          Main.do
        end
        
        it "should loop infinitely" do
          Main.should_receive(:loop).with(no_args).and_yield
          Main.do
        end
        
        it "should print out '>> '" do
          Kernel.should_receive(:printf).with(">> ")
          Main.do
        end
        
        it "should read from STDIN" do
          STDIN.should_receive(:read).and_return "STDIN"
          Main.do
        end
        
        it "should send the contents of STDIN to Command.execute" do
          Command.should_receive(:execute).with("STDIN")
          Main.do
        end
      end
    end
    
    describe OutputFormatter do
      before(:each) do
        @formatter = Shell::OutputFormatter.new
        @obj = mock 'an-object'
      end
      
      it "should call to_s on the object" do
        @obj.should_receive(:to_s).and_return "some result"
        @formatter.format(@obj)
      end
      
      describe "class format convenience method" do
        before(:each) do
          @formatter = mock 'formatter', :format => "some output"
          Shell::OutputFormatter.stub!(:new).and_return @formatter
          
          @an_object = mock 'an object'
        end
        
        it "should call new" do
          Shell::OutputFormatter.should_receive(:new).with(no_args).and_return @formatter
          Shell::OutputFormatter.format(@an_object)
        end
        
        it "should call format with the object" do
          @formatter.should_receive(:format).with(@an_object).and_return "some output"
          Shell::OutputFormatter.format(@an_object)
        end
      end
    end
  end
end
