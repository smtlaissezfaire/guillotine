require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  module Expression
    describe "expressions" do
      before :each do
        @ar_column = mock 'ar column'
        @ar_object = mock 'ActiveRecord object', :key => @ar_column
      end
      
      describe Base do
        describe "==" do
          it "should be == if the two objects have the same key and value" do
            Base.new("foo", "bar").should == Base.new("foo", "bar")
          end
          
          it "should be == if the two objects are the same object (they are equal?)" do
            obj = Base.new("baz", "quxx")
            obj.should == obj
          end
          
          it "should not be == if the two objects have different values" do
            Base.new("foo", "bar").should_not == Base.new("foo", "baz")
          end
          
          it "should not be == if they do not share neither the same key" do
            Base.new("one", "two").should_not == Base.new("three", "two")
          end
        end
        
        describe "eql?" do
          it "should be eql? if the two objects have the same key and value" do
            Base.new("foo", "bar").should eql(Base.new("foo", "bar"))
          end
          
          it "should be eql? if the two objects are the same object (they are equal?)" do
            obj = Base.new("baz", "quxx")
            obj.should eql(obj)
          end
          
          it "should not be eql? if the two objects have different values" do
            Base.new("foo", "bar").should_not eql(Base.new("foo", "baz"))
          end
          
          it "should not be eql? if they do not share neither the same key" do
            Base.new("one", "two").should_not eql(Base.new("three", "two"))
          end
        end

      end
      
      describe Equal do
        it "should have the key which it inits with" do
          Equal.new("foo", "bar").key.should == "foo"
        end
        
        it "should have the value which it inits with" do
          Equal.new("foo", "bar").value.should == "bar"
        end
        
        it "should have to_lambda, in which obj.key == value" do
          @ar_object.should_receive("key").and_return @ar_column
          @ar_column.should_receive(:==).with("value")
          lambda = Equal.new('key', "value").to_lambda
          lambda.call(@ar_object)
        end
      end
      
      describe NotEqual do
        it "should have to_lambda, in which !(obj.key == value)" do
          @ar_object.should_receive("key").and_return @ar_column
          @ar_column.should_receive(:==).with("value")
          lambda = Equal.new('key', "value").to_lambda
          lambda.call(@ar_object)
        end
        
        it "should negate the results" do
          @ar_column.stub!("==").and_return false
          lambda = NotEqual.new('key', "value").to_lambda
          lambda.call(@ar_object).should == true
        end
      end
      
      describe LessThan do
        it "should have to_lambda, in which obj.key < value" do
          @ar_object.should_receive("key").and_return @ar_column
          @ar_column.should_receive(:<).with("value")
          lambda = LessThan.new('key', "value").to_lambda
          lambda.call(@ar_object)
        end
      end
      
      describe LessThanOrEqualTo do
        it "should have to_lambda, in which obj.key <= value" do
          @ar_object.should_receive("key").and_return @ar_column
          @ar_column.should_receive(:<=).with("value")
          lambda = LessThanOrEqualTo.new('key', "value").to_lambda
          lambda.call(@ar_object)
        end
      end

      describe GreaterThan do
        it "should have to_lambda, in which obj.key > value" do
          @ar_object.should_receive("key").and_return @ar_column
          @ar_column.should_receive(:>).with("value")
          lambda = GreaterThan.new('key', "value").to_lambda
          lambda.call(@ar_object)
        end
      end
      
      describe GreaterThanOrEqualTo do
        it "should have to_lambda, in which obj.key >= value" do
          @ar_object.should_receive("key").and_return @ar_column
          @ar_column.should_receive(:>=).with("value")
          lambda = GreaterThanOrEqualTo.new('key', "value").to_lambda
          lambda.call(@ar_object)
        end
      end
      
      describe IsNull do
        it "should have to_lambda, in which obj.key == nil" do
          @ar_object.should_receive("key").and_return @ar_column
          @ar_column.should_receive(:==).with(nil)
          lambda = IsNull.new('key').to_lambda
          lambda.call(@ar_object)
        end
      end
      
      describe IsNotNull do
        it "should have to_lambda, in which !(obj.key == nil)" do
          @ar_object.should_receive("key").and_return @ar_column
          @ar_column.should_receive(:==).with(nil)
          lambda = IsNotNull.new('key').to_lambda
          lambda.call(@ar_object)
        end
        
        it "should negate the value of the lambda" do
          @ar_column.stub!("==").and_return false
          lambda = IsNotNull.new('key').to_lambda
          lambda.call(@ar_object).should == true
        end
      end
      
      describe Like do
        # TODO.  Could use regex's with .* replacing
        # % signs
      end
    end
  end
end
