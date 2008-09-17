require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module TestSupport
    describe RSpec do
      describe "interface" do
        it "should respond to before_each" do
          RSpec.should respond_to(:before_each)
        end
        
        it "should respond to before_all" do
          RSpec.should respond_to(:before_all)
        end
      end
      
      describe "an instance" do
        before :each do
          @connection = mock 'a connection'
          Connection.stub!(:new).and_return @connection
          
          @ar_base = mock 'active record base class'
          @ar_base_connection = mock 'ar base connection'
          @ar_base.stub!(:connection).and_return @ar_base_connection
          @rspec = RSpec.new
          @rspec.active_record_base = @ar_base
          
          MysqlOverrider.stub!(:new).and_return overrider
        end
        
        it "should create a new connection when calling the connection method" do
          Connection.should_receive(:new).and_return @connection
          @rspec.connection
        end
        
        it "should return the connection" do
          @rspec.connection.should == @connection
        end
        
        it "should only create the connection *once*" do
          Connection.should_receive(:new).once.and_return @connection
          @rspec.connection
          @rspec.connection
        end
        
        it "should allow assignment of the active record base class" do
          a_mock_ar = mock 'an ar base class'
          @rspec.active_record_base = a_mock_ar
          @rspec.active_record_base.should == a_mock_ar
        end
        
        it "should use ActiveRecord::Base by default" do
          rspec = RSpec.new
          rspec.active_record_base.should equal(::ActiveRecord::Base)
        end
        
        it "should find active record's connection" do
          a_connection = mock 'ar connection'
          @ar_base.should_receive(:connection).and_return a_connection
          @rspec.active_record_connection
        end
        
        it "should return the connection" do
          @rspec.active_record_connection.should equal(@ar_base_connection)
        end
        
        def overrider
          @overrider ||= mock 'mysql overrider'
        end
        
        it "should create a mysql overrider with the two connections" do
          MysqlOverrider.should_receive(:new).with(@ar_base_connection, @connection).and_return overrider
          @rspec.mysql_overrider
        end
        
        it "should return the overrider" do
          @rspec.mysql_overrider.should equal(overrider)
        end
        
        it "should only create the overrider *once*" do
          MysqlOverrider.should_receive(:new).once.and_return overrider
          @rspec.mysql_overrider
          @rspec.mysql_overrider
        end
      end
    end
  end
end
