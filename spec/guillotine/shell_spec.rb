require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe Shell do
    describe "start" do
      before(:each) do
        Shell::Main.stub!(:do)
      end
      
      it "should call Main.do" do
        Shell::Main.should_receive(:do)
        Shell.start
      end
    end
  end
end
