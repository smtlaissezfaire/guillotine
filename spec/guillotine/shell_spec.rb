require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  module Shell
    describe "start" do
      before(:each) do
        Main.stub!(:do)
      end
      
      it "should call Main.do" do
        Main.should_receive(:do)
        Shell.start
      end
    end
    
    describe "Main" do
      before(:each) do
        Main.stub!(:loop).and_yield
        Kernel.stub!(:puts)
        Kernel.stub!(:printf)
        Kernel.stub!(:gets).and_return "input"
        Command.stub!(:execute).and_return "some output"
      end
      
      describe "do" do
        before(:each) do
          Main.stub!(:output_error).and_return "error output"
        end
        
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
        
        it "should read from cmd-line" do
          Kernel.should_receive(:gets).and_return "input"
          Main.do
        end
        
        it "should chomp any \n's off the end of the input" do
          Kernel.stub!(:gets).and_return "exit\n"
          Command.should_receive(:execute).with("exit")
          Main.do
        end
        
        it "should send the contents of STDIN to Command.execute" do
          Command.should_receive(:execute).with("input")
          Main.do
        end
        
        it "should rescue any Runtime Error" do
          Command.stub!(:execute).and_raise(RuntimeError)
          lambda { 
            Main.do
          }.should_not raise_error
        end
        
        it "should output the error" do
          error = RuntimeError.new("an error occurred")
          Command.stub!(:execute).and_raise(error)
          
          Main.should_receive(:output_error).with(error)
          Main.do
        end
      end
      
      describe "outputting an error" do
        before(:each) do
          @error = mock 'an error', :message => "the message"
          Kernel.stub!(:puts).and_return "some output"
        end
        
        it "should call the error's message" do
          @error.should_receive(:message).with(no_args).and_return "some message"
          Main.output_error(@error)
        end
        
        it "should output the message on the error" do
          Kernel.should_receive(:puts).with("the message").and_return "some message"
          Main.output_error(@error)
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
