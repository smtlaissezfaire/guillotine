require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Transactions
    describe Transaction do
      before :each do
        Store.stub!(:register)
      end
      
      it "should have a unique identifier" do
        t1, t2 = Transaction.new, Transaction.new
        t1.transaction_id.should_not == t2.transaction_id
        t2.transaction_id.should_not == t1.transaction_id
      end
      
      it "should be the same, always, for the same instance" do
        t1 = Transaction.new
        t1.transaction_id.should == t1.transaction_id
      end
      
      it "should use the IdGenerator to generate the symbol" do
        t = Transaction.new
        t.transaction_id.should be_a_kind_of(Symbol)
      end
      
      it "should create the transaction id on initialization" do
        IdGenerator.should_receive(:generate)
        Transaction.new
      end
    end
  end
end
