require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module ActiveRecord
    describe ConnectionAdapter do
      before :each do
        @connection = User.connection
        @adapter = ConnectionAdapter.new(@connection)
      end
      
      it "should initialize with a connection" do
        adapter = ConnectionAdapter.new(@connection)
        adapter.connection.should equal(@connection)
      end
      
      it "should delegate it's methods to the connection (assuming it doesn't have the method)" do
        @connection.should_receive(:adapter_name).and_return nil
        @adapter.adapter_name
      end
      
      it "should raise a NoMethodError error if the connection does not respond_to? the method" do
        lambda { 
          @adapter.foo_bar_baz
        }.should raise_error(NoMethodError)
      end
      
      it "should respond_to? the method if the method is defined" do
        @adapter.should respond_to(:connection)
      end
      
      it "should respond_to? the method if the connection respond_to? the method" do
        @connection.methods.each do |instance_method|
          @adapter.should respond_to(instance_method)
        end
      end
      
      it "should not respond_to? the method if it is not defined on the object or the connection" do
        @adapter.respond_to?(:foo_bar_baz).should_not be_true
      end
    end
  end
end
