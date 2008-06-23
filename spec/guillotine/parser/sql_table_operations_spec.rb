require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe DropTableParser do
      include ParserSpecHelper
      
      before :each do
        @parser = DropTableParser.new
        DataStore.stub!(:drop_table).and_return nil
      end
      
      it "should parse DROP TABLE foo" do
        parse("DROP TABLE foo").should_not be_nil
      end
      
      it "should call the Datastore" do
        DataStore.should_receive(:drop_table).with(:foo)
        parse_and_eval("DROP TABLE foo")
      end
      
      it "should call the datastore with the correct table name" do
        DataStore.should_receive(:drop_table).with(:bar)
        parse_and_eval("DROP TABLE bar")
      end
      
      it "should parse DROP    TABLE foo" do
        parse("DROP    TABLE foo").should_not be_nil
      end
      
      it "should parse DROP TABLE    foo" do
        parse("DROP TABLE          foo").should_not be_nil
      end
    end
  end
end
