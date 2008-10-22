require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLWhereConditionParser do
      include ParserSpecHelper
      
      before :each do
        @parser = SQLWhereConditionParser.new
        @equal_expression = Expressions::Equal.new(:foo, 7)

        @foo_7 = @equal_expression
        @bar_8 = Expressions::Equal.new(:bar, 8)
        @baz_9 = Expressions::Equal.new(:baz, 9)
        @bar_equals_eight_expr = Expressions::Equal.new(:bar, 8)
      end
      
      it "should parse a simple where clause with one expression" do
        parse_and_eval("WHERE foo = 7").should eql(@equal_expression)
      end
      
      it "should parse a simple where clause with spaces" do
        parse_and_eval("WHERE            foo    =  7").should eql(@equal_expression)
      end
      
      it "should parse a clause with a != expression" do
        pending "FIXME" do
          parse("WHERE foo != 7").should_not be_nil
        end
      end
      
      describe "AND conditions" do
        before :each do
          @and_condition = Guillotine::Conditions::AndCondition
        end
        
        it "should parse a simple clause with two AND expressions" do
          and_expression = @and_condition.new(@equal_expression, @equal_expression)
          parse_and_eval("WHERE foo = 7 AND foo = 7").should eql(and_expression)
        end
        
        it "should parse a simple clause with two AND expressions" do
          and_expression = @and_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE foo = 7 AND bar = 8").should eql(and_expression)
        end
        
        it "should parse a simple clause with two AND expressions, with random spaces in between the 'AND' condition" do
          and_expression = @and_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE             foo = 7 AND            bar    =  8").should eql(and_expression)
        end
        
        it "should parse a clause with three AND expressions" do
          first_and_expr = @and_condition.new(@bar_8, @baz_9)
          second_and_expr = @and_condition.new(@foo_7, first_and_expr)
          
          node = parse_and_eval("WHERE foo = 7 AND bar = 8 AND baz=9")
          node.should eql(second_and_expr)
        end
        
        it "should parse a clause with one expression and parenthesis" do
          parse_and_eval("WHERE (foo = 7)").should eql(@equal_expression)
        end
        
        it "should parse a clause with two expressions and parenthesis around them" do
          and_expression = @and_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE (foo = 7 AND bar = 8)").should eql(and_expression)
        end
        
        it "should parse a clause with two expressions and parenthesis around them with a space" do
          and_expression = @and_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE ( foo = 7 AND bar = 8 )").should eql(and_expression)
        end

        it "should parse a clause with two expressions and parenthesis around them with multiple space" do
          and_expression = @and_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE (          foo    =    7   AND    bar  = 8              )").should eql(and_expression)
        end

        it "should NOT parse a clause with two expressions and no matching parenthesis" do
          parse("WHERE ( foo = 7 AND bar = 8").should be_nil
        end
        
        it "should parse a clause with two parenthesis around it" do
          and_expression = @and_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE ((foo = 7 AND bar = 8))").should eql(and_expression)
        end
      end
      
      describe "OR condition" do
        before :each do
          @or_condition = ::Guillotine::Conditions::OrCondition
        end
        
        it "should parse a simple clause with two OR expressions" do
          or_expression = @or_condition.new(@equal_expression, @equal_expression)
          parse_and_eval("WHERE foo = 7 OR foo = 7").should eql(or_expression)
        end
        
        it "should parse a simple clause with two OR expressions" do
          or_expression = @or_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE foo = 7 OR bar = 8").should eql(or_expression)
        end
        
        it "should parse a simple clause with two OR expressions, with random spaces in between the 'OR' condition" do
          or_expression = @or_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE             foo = 7 OR            bar    =  8").should eql(or_expression)
        end
        
        it "should parse a clause with three OR expressions" do
          first_and_expr = @or_condition.new(@bar_8, @baz_9)
          second_and_expr = @or_condition.new(@foo_7, first_and_expr)
          
          node = parse_and_eval("WHERE foo = 7 OR bar = 8 OR baz=9")
          node.should eql(second_and_expr)
        end
        
        it "should parse a clause with one expression and parenthesis" do
          parse_and_eval("WHERE (foo = 7)").should eql(@equal_expression)
        end
        
        it "should parse a clause with two expressions and parenthesis around them" do
          or_expression = @or_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE (foo = 7 OR bar = 8)").should eql(or_expression)
        end
        
        it "should parse a clause with two expressions and parenthesis around them with a space" do
          or_expression = @or_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE ( foo = 7 OR bar = 8 )").should eql(or_expression)
        end

        it "should parse a clause with two expressions and parenthesis around them with multiple space" do
          or_expression = @or_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE (          foo    =    7   OR    bar  = 8              )").should eql(or_expression)
        end

        it "should NOT parse a clause with two expressions and no matching parenthesis" do
          parse("WHERE ( foo = 7 OR bar = 8").should be_nil
        end
        
        it "should parse a clause with two parenthesis around it" do
          or_expression = @or_condition.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE ((foo = 7 OR bar = 8))").should eql(or_expression)
        end
      end
    end
  end
end
