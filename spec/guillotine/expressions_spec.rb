require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe Expressions do
    describe "Syntax classes" do
      it "should find the syntax class for the equal sign" do
        Expressions.find_class_for("=").should == Expressions::Equal
      end
      
      it "should find the syntax class for the not equal sign" do
        Expressions.find_class_for("!=").should == Expressions::NotEqual
      end
      
      it "should find the syntax class for the less than sign" do
        Expressions.find_class_for("<").should == Expressions::LessThan
      end
      
      it "should find the syntax class for the less than or equal sign" do
        Expressions.find_class_for("<=").should == Expressions::LessThanOrEqualTo
      end
      
      it "should find the syntax class for the greater than sign" do
        Expressions.find_class_for(">").should == Expressions::GreaterThan
      end
      
      it "should find the syntax class for the greater than or equal to sign" do
        Expressions.find_class_for(">=").should == Expressions::GreaterThanOrEqualTo
      end
      
      it "should find the syntax class for the IS NULL expression" do
        Expressions.find_class_for("IS NULL").should == Expressions::IsNull
      end
      
      it "should find the syntax class for the IS NOT NULL expression" do
        Expressions.find_class_for("IS NOT NULL").should == Expressions::IsNotNull
      end
      
      it "should find the syntax class for the AND expression" do
        Expressions.find_class_for("AND").should == Guillotine::Conditions::AndCondition
      end
      
      it "should find the syntax class for the OR than sign" do
        Expressions.find_class_for("OR").should == Guillotine::Conditions::OrCondition
      end
      
      it "should raise an error if it is given a syntax class it doesn't know how to dispatch on" do
        lambda { 
          Expressions.find_class_for("FOO BAR BAZ")
        }.should raise_error(Expressions::UnknownSyntaxError, "Unknown joiner 'FOO BAR BAZ'")
      end
      
      describe "syntax classes dispatcher" do
        it "should have syntax classes as a private method" do
          Expressions.private_methods.should include("syntax_classes")
        end
      end
    end
  end
end
