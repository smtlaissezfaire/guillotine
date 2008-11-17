require File.dirname(__FILE__) + "/../../../spec_helper"

module Guillotine
  module Shell
    describe OutputFormatter::ColumnExtractor do
      before(:each) do
        @extractor = OutputFormatter::ColumnExtractor.new
      end
      
      it "should construct a hash with the column name" do
        @extractor.extract(:foo, [{ :foo => "bar" }]).should include(:column => :foo)
      end
      
      it "should use the proper column name" do
        @extractor.extract(:bar, [{ :bar => "bar"}]).should include(:column => :bar)
      end
      
      it "should raise an error if it can't find the key" do
        lambda {
          @extractor.extract(:bar, [{ :foo => "1"}])
        }.should raise_error(OutputFormatter::ColumnExtractor::UnfoundKeyError, "Could not find the key 'bar'")
      end
      
      it "should raise an error with the correct name" do
        lambda {
          @extractor.extract(:key_looking_for, [{ :foo => "1"}])
        }.should raise_error(OutputFormatter::ColumnExtractor::UnfoundKeyError, "Could not find the key 'key_looking_for'")
      end
      
      it "should return an array with one value" do
        @extractor.extract(:foo, [{ :foo => "foo" }]).should include(:values => ["foo"])
      end
      
      it "should return an array with two values" do
        result = @extractor.extract(:foo, [{ :foo => "foo" }, { :foo => "bar" }])
        result.should include(:values => ["foo", "bar"])
      end
      
      it "should to_s a value" do
        result = @extractor.extract(:foo, [{ :foo => 1 }])
        result.should include(:values => ["1"])
      end
    end
  end
end
