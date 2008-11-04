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
  end
end
