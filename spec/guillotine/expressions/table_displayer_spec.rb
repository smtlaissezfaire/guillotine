require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe TableDisplayer do
      before(:each) do
        @datastore = mock 'datastore'
      end
      
      it "should have the datastore" do
        displayer = TableDisplayer.new(@datastore)
        displayer.datastore.should equal(@datastore)
      end
      
      describe "to_sql" do
        it "should return the string 'SHOW TABLES'" do
          TableDisplayer.new(@datastore).to_sql.should == "SHOW TABLES"
        end
      end
      
      describe "call" do
        before(:each) do
          @datastore.stub!(:table_names).and_return ["a", "b"]
        end
        
        it "should call the table_names method on the datastore" do
          displayer = TableDisplayer.new(@datastore)
          
          @datastore.should_receive(:table_names).and_return ["a", "b"]
          
          displayer.call
        end
      end
      
      describe "==" do
        it "should always be equal to another object that is a TableDisplayer with the same datastore" do
          TableDisplayer.new(@datastore).should == TableDisplayer.new(@datastore)
        end
        
        it "should not be == if it has a different datastore" do
          TableDisplayer.new(mock('a different datastore')).should_not == TableDisplayer.new(@datastore)
          TableDisplayer.new(@datastore).should_not == TableDisplayer.new(mock('a different datastore'))
        end
        
        it "should not be == if the two datastores are ==, but equal?" do
          other_datastore = mock 'other datastore', :== => true
          
          TableDisplayer.new(other_datastore).should_not == TableDisplayer.new(@datastore)
          TableDisplayer.new(@datastore).should_not == TableDisplayer.new(other_datastore)
        end
        
        it "should be false if given a different object" do
          (TableDisplayer.new(@datastore) == Object.new).should be_false
        end
      end
      
      describe "eql?" do
        it "should always be equal to another object that is a TableDisplayer with the same datastore" do
          TableDisplayer.new(@datastore).should eql(TableDisplayer.new(@datastore))
        end
        
        it "should not be eql if it has a different datastore" do
          TableDisplayer.new(mock('a different datastore')).should_not eql(TableDisplayer.new(@datastore))
          TableDisplayer.new(@datastore).should_not eql(TableDisplayer.new(mock('a different datastore')))
        end
        
        it "should not be eql if the two datastores are eql, but equal?" do
          other_datastore = mock 'other datastore', :eql => true
          
          TableDisplayer.new(other_datastore).should_not eql(TableDisplayer.new(@datastore))
          TableDisplayer.new(@datastore).should_not eql(TableDisplayer.new(other_datastore))
        end
        
        it "should be false if given a different object" do
          (TableDisplayer.new(@datastore).eql?(Object.new)).should be_false
        end
      end
    end
  end
end
