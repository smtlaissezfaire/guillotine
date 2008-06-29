require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Transactions
    describe Store do
      before :each do
        Store.clear_instances!
      end
      
      it "should have no instances, if there are no transactions" do
        Store.instances.should == []
      end
      
      it "should keep track of a new instance" do
        t = Transaction.new
        Store.instances.should == [t]
      end
      
      it "should be able to clear the instances (just for tests)" do
        t = Transaction.new
        Store.clear_instances!
        Store.instances.should be_empty
      end
    end
  end
end
