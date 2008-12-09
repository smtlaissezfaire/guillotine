require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module TestSupport
    describe RSpec do
      describe "class methods" do
        before :each do
          RSpec.reset_instance!
          @rspec_instance = mock 'an rspec instance'
        end
        
        it "should respond to before_each" do
          RSpec.should respond_to(:before_each)
        end
        
        it "should respond to before_all" do
          RSpec.should respond_to(:before_all)
        end
        
        it "should have an instance" do
          RSpec.instance.should be_a_kind_of(RSpec)
        end
        
        it "should only instantiate an instance once" do
          RSpec.should_receive(:new).once.and_return @rspec_instance
          RSpec.instance
          RSpec.instance
        end
        
        describe "before all" do
          before :each do
            RSpec.stub!(:new).and_return @rspec_instance
          end
          
          it "should call the instance's start method" do
            @rspec_instance.should_receive(:start).and_return true
            RSpec.before_all
          end
        end
        
        describe "before each" do
          before :each do
            RSpec.stub!(:new).and_return @rspec_instance
          end
          
          it "should call the instance's reload method" do
            @rspec_instance.should_receive(:reload).and_return true
            RSpec.before_each
          end
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
        
        describe "starting" do
          before :each do
            @array_of_tables = ["users"]
            @ar_base_connection.stub!(:tables).and_return @array_of_tables
            Guillotine::DataStore.stub!(:create_table)
          end
          
          it "should call mysql_overrider" do
            MysqlOverrider.should_receive(:new).and_return overrider
            @rspec.start
          end
          
          it "should find the tables in the database through the mysql connection" do
            @ar_base_connection.should_receive(:tables).and_return @array_of_tables
            @rspec.start
          end
          
          it "should add the users table to the Guillotine::DataStore" do
            Guillotine::DataStore.should_receive(:create_table).with("users")
            @rspec.start
          end
          
          it "should return true" do
            @rspec.start.should be_true
          end
        end
        
        describe "reload" do
          before :each do
            @connection.stub!(:rollback!).and_return []
          end
          
          it "should call the guillotine test connection's rollback! method" do
            @connection.should_receive(:rollback!).with(no_args).and_return []
            @rspec.reload
          end
          
          it "should return true" do
            @rspec.reload.should be_true
          end
        end
      end
    end
  end
end
