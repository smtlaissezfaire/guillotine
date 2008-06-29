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
      
      it "should remove the instance after the transaction has ben commited" do
        t = Transaction.new
        t.commit
        Store.instances.should be_empty
      end
      
      it "should leave other instances around which aren't commited" do
        t1 = Transaction.new
        t2 = Transaction.new
        t1.commit
        Store.instances.should == [t2]
      end
      
      it "should remove the instance after a rollback" do
        t = Transaction.new
        t.rollback
        Store.instances.should be_empty
      end
    end
  end
end
