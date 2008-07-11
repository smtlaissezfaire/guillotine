require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  module ActiveRecord
    describe Extensions do
      it "should have activerecord loaded" do
        lambda { 
          ::ActiveRecord::Base
        }.should_not raise_error
      end
      
      it "should have the method guillotine_model" do
        Guillotine::ActiveRecord::Extensions.instance_methods.should include("guillotine_model")
      end
      
      it "should have the instance method mixed into ActiveRecord::Base" do
        ::ActiveRecord::Base.methods.should include("guillotine_model")
      end
      
      describe "when the table is empty" do
        before :each do
          @model = Class.new(::ActiveRecord::Base) do
            set_table_name :foo
          end

          @a_mock = mock 'a mock activerecord object'
          @model.stub!(:find).and_return [@a_mock]

          @datastore = Guillotine::DataStore
          @datastore.stub!(:create_table).and_return nil
          @datastore.stub!(:initial_insert).and_return nil          
        end
        
        it "should create the table when mixed in" do
          Guillotine::DataStore.should_receive(:create_table).with(:foo)
          @model.instance_eval { guillotine_model }
        end
        
        it "should create the table with the appropriate table name" do
          Guillotine::DataStore.should_receive(:create_table).with(:bar)
          @model.instance_eval do
            set_table_name :bar
            guillotine_model
          end
        end
        
        it "should fetch the contents" do
          @model.should_receive(:find).with(:all).and_return [@a_mock]
          
          @model.instance_eval do
            guillotine_model
          end
        end
        
        it "should add the contents to the datastore" do
          @datastore.should_receive(:initial_insert).with([@a_mock])
          @ar_class.stub!(:find).and_return [@a_mock]
          
          @model.instance_eval do
            guillotine_model
          end
        end
      end
      
      describe "when the table isn't empty" do
        xit "TODO...From: #{caller[0]}"
      end
      
      describe "when the table already exists" do
        xit "TODO...From: #{caller[0]}"
      end
    end
  end
end
