require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module StatementExecutors
    describe MultiExecutor do
      it "should accept a string as it's param" do
        obj = MultiExecutor.new("some string")
        obj.string.should == "some string"
      end
      
      it "should report back the correct string" do
        obj = MultiExecutor.new("foo")
        obj.string.should == "foo"
      end
      
      describe "executing a query" do
        before(:each) do
          @executor = mock 'an executor'
          MultiExecutor.reset_delimiter!
        end
        
        def new_multi_executor(string)
          obj = MultiExecutor.new(string)
          obj.executor = @executor
          obj
        end
        
        it "should have Guillotine::StatementExecutor as the default executor" do
          obj = MultiExecutor.new("foo")
          obj.executor.should be_a_kind_of(Guillotine::StatementExecutor)
        end
        
        it "should be able to set the executor" do
          obj = new_multi_executor("foo")
          obj.executor = @executor
          obj.executor.should equal(@executor)
        end
        
        it "should call the statement executor's execute method" do
          obj = new_multi_executor("SQL STATEMENT")
          @executor.should_receive(:execute).with("SQL STATEMENT")
          obj.execute
        end
        
        it "should strip the ';' from the string" do
          obj = new_multi_executor("SQL STATEMENT;")
          @executor.should_receive(:execute).with("SQL STATEMENT")
          obj.execute
        end
        
        it "should execute two statements with a semicolon as a delimiter" do
          obj = new_multi_executor("FIRST; SECOND")
          @executor.should_receive(:execute).twice
          obj.execute
        end
        
        it "should have the ; as the default delimiter" do
          new_multi_executor("foo").delimiter.should == ";"
        end
        
        it "should be able to set the delimiter" do
          MultiExecutor.delimiter = "%"
          obj = new_multi_executor("foo")
          obj.delimiter.should == "%"
        end
        
        it "should execute multiple statements with a different delimiter" do
          MultiExecutor.delimiter = "%"
          obj = new_multi_executor("foo % bar")
          
          @executor.should_receive(:execute).twice
          obj.execute
        end
        
        it "should be able to reset the default delimiter" do
          MultiExecutor.delimiter = "%"
          MultiExecutor.reset_delimiter!
          MultiExecutor.delimiter.should == ";"
        end
        
        it "should keep the delimiter after a class has been instantiated" do
          MultiExecutor.delimiter = "%"
          instance = MultiExecutor.new("foo")
          MultiExecutor.delimiter = ";"
          instance.delimiter.should == "%"
        end
        
        it "should return the results of the first statement, if only one" do
          obj = new_multi_executor("some statement")
          @executor.stub!(:execute).and_return "foo"
          obj.execute.should == "foo"
        end
        
        it "should return two results" do
          obj = new_multi_executor("some statement; statement 2")
          @executor.stub!(:execute).and_return("foo", "bar")
          obj.execute.should == ["foo", "bar"]
        end
      end
      
      describe "parsing a query" do
        before(:each) do
          @executor = mock 'an executor'
          MultiExecutor.reset_delimiter!
        end
        
        def new_multi_executor(string)
          obj = MultiExecutor.new(string)
          obj.executor = @executor
          obj
        end
        
        it "should call the statement executor's parse method" do
          obj = new_multi_executor("SQL STATEMENT")
          @executor.should_receive(:parse).with("SQL STATEMENT")
          obj.parse
        end
        
        it "should strip the ';' from the string" do
          obj = new_multi_executor("SQL STATEMENT;")
          @executor.should_receive(:parse).with("SQL STATEMENT")
          obj.parse
        end
        
        it "should parse two statements with a semicolon as a delimiter" do
          obj = new_multi_executor("FIRST; SECOND")
          @executor.should_receive(:parse).twice
          obj.parse
        end
        
        it "should return the results of the first statement, if only one" do
          obj = new_multi_executor("some statement")
          @executor.stub!(:parse).and_return "foo"
          obj.parse.should == "foo"
        end
        
        it "should return two results" do
          obj = new_multi_executor("some statement; statement 2")
          @executor.stub!(:parse).and_return("foo", "bar")
          obj.parse.should == ["foo", "bar"]
        end
      end
    end
  end
end
