require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Shell
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
