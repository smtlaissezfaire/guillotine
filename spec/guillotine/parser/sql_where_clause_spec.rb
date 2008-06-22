require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLWhereConditionParser do
      include ParserSpecHelper
      
      before :each do
        @parser = SQLWhereConditionParser.new
        @equal_expression = Expression::Equal.new(:foo, 7)

        @foo_7 = @equal_expression
        @bar_8 = Expression::Equal.new(:bar, 8)
        @baz_9 = Expression::Equal.new(:baz, 9)
        @bar_equals_eight_expr = Expression::Equal.new(:bar, 8)
      end
      
      it "should parse a simple where clause with one expression" do
        parse_and_eval("WHERE foo = 7").should eql(@equal_expression)
      end
      
      it "should parse a simple where clause with spaces" do
        parse_and_eval("WHERE            foo    =  7").should eql(@equal_expression)
      end
      
      describe "AND conditions" do
        it "should parse a simple clause with two AND expressions" do
          and_expression = ConjunctionConditionNode.new(@equal_expression, @equal_expression)
          parse_and_eval("WHERE foo = 7 AND foo = 7").should eql(and_expression)
        end
        
        it "should parse a simple clause with two AND expressions" do
          and_expression = ConjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE foo = 7 AND bar = 8").should eql(and_expression)
        end
        
        it "should parse a simple clause with two AND expressions, with random spaces in between the 'AND' condition" do
          and_expression = ConjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE             foo = 7 AND            bar    =  8").should eql(and_expression)
        end
        
        it "should parse a clause with three AND expressions" do
          first_and_expr = ConjunctionConditionNode.new(@bar_8, @baz_9)
          second_and_expr = ConjunctionConditionNode.new(@foo_7, first_and_expr)
          
          node = parse_and_eval("WHERE foo = 7 AND bar = 8 AND baz=9")
          node.should eql(second_and_expr)
        end
        
        it "should parse a clause with one expression and parenthesis" do
          pending 'should it?'
          parse_and_eval("WHERE (foo = 7)").should eql(@equal_expression)     
        end
        
        it "should parse a clause with two expressions and parenthesis around them" do
          and_expression = ConjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE (foo = 7 AND bar = 8)").should eql(and_expression)
        end
        
        it "should parse a clause with two expressions and parenthesis around them with a space" do
          and_expression = ConjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE ( foo = 7 AND bar = 8 )").should eql(and_expression)
        end

        it "should parse a clause with two expressions and parenthesis around them with multiple space" do
          and_expression = ConjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE (          foo    =    7   AND    bar  = 8              )").should eql(and_expression)
        end

        it "should NOT parse a clause with two expressions and no matching parenthesis" do
          parse("WHERE ( foo = 7 AND bar = 8").should be_nil
        end
        
        it "should parse a clause with two parenthesis around it" do
          and_expression = ConjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE ((foo = 7 AND bar = 8))").should eql(and_expression)
        end
      end
      
      describe "OR condition" do
        it "should parse a simple clause with two OR expressions" do
          or_expression = DisjunctionConditionNode.new(@equal_expression, @equal_expression)
          parse_and_eval("WHERE foo = 7 OR foo = 7").should eql(or_expression)
        end
        
        it "should parse a simple clause with two OR expressions" do
          or_expression = DisjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE foo = 7 OR bar = 8").should eql(or_expression)
        end
        
        it "should parse a simple clause with two OR expressions, with random spaces in between the 'OR' condition" do
          or_expression = DisjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE             foo = 7 OR            bar    =  8").should eql(or_expression)
        end
        
        it "should parse a clause with three OR expressions" do
          first_and_expr = DisjunctionConditionNode.new(@bar_8, @baz_9)
          second_and_expr = DisjunctionConditionNode.new(@foo_7, first_and_expr)
          
          node = parse_and_eval("WHERE foo = 7 OR bar = 8 OR baz=9")
          node.should eql(second_and_expr)
        end
        
        it "should parse a clause with one expression and parenthesis" do
          pending 'should it?'
          parse_and_eval("WHERE (foo = 7)").should eql(@equal_expression)     
        end
        
        it "should parse a clause with two expressions and parenthesis around them" do
          or_expression = DisjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE (foo = 7 OR bar = 8)").should eql(or_expression)
        end
        
        it "should parse a clause with two expressions and parenthesis around them with a space" do
          or_expression = DisjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE ( foo = 7 OR bar = 8 )").should eql(or_expression)
        end

        it "should parse a clause with two expressions and parenthesis around them with multiple space" do
          or_expression = DisjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE (          foo    =    7   OR    bar  = 8              )").should eql(or_expression)
        end

        it "should NOT parse a clause with two expressions and no matching parenthesis" do
          parse("WHERE ( foo = 7 OR bar = 8").should be_nil
        end
        
        it "should parse a clause with two parenthesis around it" do
          or_expression = DisjunctionConditionNode.new(@equal_expression, @bar_equals_eight_expr)
          parse_and_eval("WHERE ((foo = 7 OR bar = 8))").should eql(or_expression)
        end
      end
    end
  end
end
