require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  describe SQLKeyValuePairParser do
    include ParserSpecHelper
    
    before :each do
      @parser = SQLKeyValuePairParser.new
    end
    
    describe "condition" do
      describe "with '='" do
        it "should parse foo='bar'" do
          parse_and_eval("foo='bar'").should eql(Expression::Equal.new(:foo, "bar"))
        end
        
        it "should parse baz='bar'" do
          parse_and_eval("baz='bar'").should eql(Expression::Equal.new(:baz, "bar"))
        end
        
        it "should parse foo='baz'" do
          parse_and_eval("foo='baz'").should eql(Expression::Equal.new(:foo, "baz"))
        end
        
        it "should parse foo=7" do
          parse_and_eval("foo=7").should eql(Expression::Equal.new(:foo, 7))
        end
        
        it "should parse foo = 7" do
          parse_and_eval("foo = 7").should eql(Expression::Equal.new(:foo, 7))
        end
        
        it "should parse foo != 8"  do
          parse_and_eval("foo != 8").should eql(Expression::NotEqual.new(:foo, 8))
        end
        
        it "should parse foo != \"barbaz\"" do
          parse_and_eval("foo != \"barbaz\"").should eql(Expression::NotEqual.new(:foo, "barbaz"))
        end
        
        it "should parse foo > 'bar'" do
          parse_and_eval("foo > 'bar'").should eql(Expression::GreaterThan.new(:foo, "bar"))
        end
        
        it "should parse foo < 'bar'" do
          parse_and_eval("foo < 'bar'").should eql(Expression::LessThan.new(:foo, "bar"))
        end
        
        it "should parse foo >= 7" do
          parse_and_eval("foo >= 7").should eql(Expression::GreaterThanOrEqualTo.new(:foo, 7))
        end
        
        it "should parse foo <= 7" do
          parse_and_eval("foo <= 7").should eql(Expression::LessThanOrEqualTo.new(:foo, 7))
        end
        
        it "should not parse 'ISNOT NULL" do
          parse("ISNOT NULL").should be_nil
        end
        
        it "should parse foo IS NOT NULL" do
          parse_and_eval("foo IS NOT NULL").should eql(Expression::IsNotNull.new(:foo))
        end
        
        it "should parse foo 'IS  NOT NULL'" do
          parse_and_eval("foo IS  NOT NULL").should eql(Expression::IsNotNull.new(:foo))
        end
        
        it "should parse foo 'IS NOT  NULL'" do
          parse_and_eval("foo IS NOT  NULL").should eql(Expression::IsNotNull.new(:foo))
        end
        
        it "should parse foo IS NULL" do
          parse_and_eval("foo IS NULL").should eql(Expression::IsNull.new(:foo))
        end
        
        it "should parse foo  IS NULL" do
          parse_and_eval("foo  IS NULL").should eql(Expression::IsNull.new(:foo))
        end
        
        it "should parse foo IS  NULL" do
          parse_and_eval("foo IS  NULL").should eql(Expression::IsNull.new(:foo))
        end
        
        it "should not parse fooIS NULL" do
          parse("fooIS NULL").should be_nil
        end
        
        it "should not parse foo ISNULL" do
          parse("foo ISNULL").should be_nil
        end
      end
    end
  end
end
