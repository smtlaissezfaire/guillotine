require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe Expression do
    describe "Syntax classes" do
      it "should find the syntax class for the equal sign" do
        Expression.find_class_for("=").should == Expression::Equal
      end
      
      it "should find the syntax class for the not equal sign" do
        Expression.find_class_for("!=").should == Expression::NotEqual
      end
      
      it "should find the syntax class for the less than sign" do
        Expression.find_class_for("<").should == Expression::LessThan
      end
      
      it "should find the syntax class for the less than or equal sign" do
        Expression.find_class_for("<=").should == Expression::LessThanOrEqualTo
      end
      
      it "should find the syntax class for the greater than sign" do
        Expression.find_class_for(">").should == Expression::GreaterThan
      end
      
      it "should find the syntax class for the greater than or equal to sign" do
        Expression.find_class_for(">=").should == Expression::GreaterThanOrEqualTo
      end
      
      it "should find the syntax class for the IS NULL expression" do
        Expression.find_class_for("IS NULL").should == Expression::IsNull
      end
      
      it "should find the syntax class for the IS NOT NULL expression" do
        Expression.find_class_for("IS NOT NULL").should == Expression::IsNotNull
      end
      
      it "should find the syntax class for the AND expression" do
        Expression.find_class_for("AND").should == Guillotine::ConjunctionConditionNode
      end
      
      it "should find the syntax class for the OR than sign" do
        Expression.find_class_for("OR").should == Guillotine::DisjunctionConditionNode
      end
      
      it "should raise an error if it is given a syntax class it doesn't know how to dispatch on" do
        lambda { 
          Expression.find_class_for("FOO BAR BAZ")
        }.should raise_error(Expression::UnknownSyntaxError, "Unknown joiner 'FOO BAR BAZ'")
      end
      
      describe "syntax classes constant" do
        it "should not allow an element to be added to it" do
          lambda { 
            Expression::SYNTAX_CLASSES[:foo] = "bar"          
          }.should raise_error(TypeError, "can't modify frozen hash")
        end
      end
    end
  end
end
