require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLKeyValuePairParser do
      include ParserSpecHelper
      
      before :each do
        @parser = SQLKeyValuePairParser.new
      end
      
      describe "condition" do
        describe "with '='" do
          def equal(*args)
            Expressions::Equal.new(*args)
          end
          
          def not_equal(*args)
            Expressions::NotEqual.new(*args)
          end
          
          def greater_than(*args)
            Expressions::GreaterThan.new(*args)
          end
          
          def greater_than_or_equal_to(*args)
            Expressions::GreaterThanOrEqualTo.new(*args)            
          end
          
          def less_than(*args)
            Expressions::LessThan.new(*args)
          end
          
          def less_than_or_equal_to(*args)
            Expressions::LessThanOrEqualTo.new(*args)            
          end
          
          def is_null(*args)
            Expressions::IsNull.new(*args)
          end

          def is_not_null(*args)
            Expressions::IsNotNull.new(*args)
          end
          
          it "should parse foo='bar'" do
            parse_and_eval("foo='bar'").should eql(equal(:foo, "bar"))
          end
          
          it "should parse baz='bar'" do
            parse_and_eval("baz='bar'").should eql(equal(:baz, "bar"))
          end
          
          it "should parse foo='baz'" do
            parse_and_eval("foo='baz'").should eql(equal(:foo, "baz"))
          end
          
          it "should parse foo=7" do
            parse_and_eval("foo=7").should eql(equal(:foo, 7))
          end
          
          it "should parse foo = 7" do
            parse_and_eval("foo = 7").should eql(equal(:foo, 7))
          end
          
          it "should parse foo != 8"  do
            parse_and_eval("foo != 8").should eql(not_equal(:foo, 8))
          end
          
          it "should parse foo != \"barbaz\"" do
            parse_and_eval("foo != \"barbaz\"").should eql(not_equal(:foo, "barbaz"))
          end
          
          it "should parse foo > 'bar'" do
            parse_and_eval("foo > 'bar'").should eql(greater_than(:foo, "bar"))
          end
          
          it "should parse foo < 'bar'" do
            parse_and_eval("foo < 'bar'").should eql(less_than(:foo, "bar"))
          end
          
          it "should parse foo >= 7" do
            parse_and_eval("foo >= 7").should eql(greater_than_or_equal_to(:foo, 7))
          end
          
          it "should parse foo <= 7" do
            parse_and_eval("foo <= 7").should eql(less_than_or_equal_to(:foo, 7))
          end
          
          it "should not parse 'ISNOT NULL" do
            parse("ISNOT NULL").should be_nil
          end
          
          it "should parse foo IS NOT NULL" do
            parse_and_eval("foo IS NOT NULL").should eql(is_not_null(:foo))
          end
          
          it "should parse foo 'IS  NOT NULL'" do
            parse_and_eval("foo IS  NOT NULL").should eql(is_not_null(:foo))
          end
          
          it "should parse foo 'IS NOT  NULL'" do
            parse_and_eval("foo IS NOT  NULL").should eql(is_not_null(:foo))
          end
          
          it "should parse foo IS NULL" do
            parse_and_eval("foo IS NULL").should eql(is_null(:foo))
          end
          
          it "should parse foo  IS NULL" do
            parse_and_eval("foo  IS NULL").should eql(is_null(:foo))
          end
          
          it "should parse foo IS  NULL" do
            parse_and_eval("foo IS  NULL").should eql(is_null(:foo))
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
end
