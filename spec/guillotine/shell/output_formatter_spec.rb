require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Shell
    describe OutputFormatter do
      before(:each) do
        @formatter = Shell::OutputFormatter.new
        @obj = mock 'an-object'
      end
      
      describe "puts" do
        before(:each) do
          Kernel.stub!(:puts).and_return "foo"
        end
        
        it "should format the object" do
          @formatter.should_receive(:format).with(@obj).and_return "output_string"
          @formatter.puts(@obj)
        end
        
        it "should call puts with the format results" do
          @formatter.stub!(:format).with(@obj).and_return "output_string"
          
          Kernel.should_receive(:puts).with("output_string\n")
          
          @formatter.puts(@obj)
        end
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
      
      describe "format" do
        it "should have one column name" do
          @formatter.format([{ :foo => :bar}]).should include("foo")
        end
        
        it "should output two column names" do
          @formatter.format([{ :foo => 123, :bar => :baz }]).should include("foo | bar")
        end
        
        it "should have a vertical bar before and after the column name" do
          @formatter.format([{ :foo => :bar }]).should include("| foo |")
        end
        
        it "should have a vertical bar between both columns" do
          @formatter.format([{ :foo => 123, :bar => :baz }]).should include("| foo | bar |")          
        end
        
        it "should have the first value in the table" do
          @formatter.format([{ :foo => 123 }]).should include("123")
        end
        
        it "should include the correct value" do
          @formatter.format([{ :foo => 3234 }]).should include("3234")
        end
        
        it "should have 5 spaces for a 3 value column" do
          @formatter.format([{ :foo => "123" }]).should include("| 123 |")
        end
        
        it "should include the a 3 value column with 6 spaces when a different value takes 4 spaces" do
          @formatter.format([{ :foo => "123" }, { :foo => "1234" }]).should include("| 123  |")
        end
        
        it "should include multiple columns spaced out appropriately" do
          @formatter.format([{ :foo => "123" }, { :foo => "123456" }]).should include("| 123    |")
        end
        
        it "should space out the columns appropriately" do
          @formatter.format([{ :foo => "123" }, { :foo => "123456" }]).should include("| foo    |")
        end
        
        it "should map two values side by side" do
          @formatter.format([{ :foo => "123", :bar => "123" }, { :foo => "123456", :bar => "123" }]).should include("| 123    | 123 |")
        end
        
        it "should return the string 'Empty set\n' when it tries to format an empty array" do
          Kernel.should_receive(:puts).with("Empty set\n").and_return nil
          @formatter.format([])
        end
      end
    end
  end
end
