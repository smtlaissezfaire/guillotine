require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
    
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
  
  describe SQLLimitParser do
    include ParserSpecHelper
    
    before :each do
      @parser = SQLLimitParser.new
    end
    
    it "should not parse LIMIT" do
      parse("LIMIT").should be_nil
    end
    
    it "should parse LIMIT 10" do
      parse_and_eval("LIMIT 10").should == Expression::Limit.new(10)
    end
    
    it "should parse LIMIT 20" do
      parse_and_eval("LIMIT 20").should == Expression::Limit.new(20)
    end
    
    it "should parse LIMIT  30 (with spaces)" do
      parse_and_eval("LIMIT  30").should == Expression::Limit.new(30)
    end
    
    it "should not parse LIMIT30" do
      parse("LIMIT30").should be_nil
    end
    
    it "should parse LIMIT 0" do
      parse_and_eval("LIMIT 0").should == Expression::Limit.new(0)
    end
    
    it "should not parse LIMIT -1" do
      parse("LIMIT -1").should be_nil
    end
  end
  
  describe SQLSelectParser do
    include ParserSpecHelper
    
    before :each do
      @parser = SQLSelectParser.new      
    end
    
    describe "SELECT clause" do
      it "should parse SELECT *" do
        parse_and_eval("SELECT *").should == Expression::Select.new("*")
      end
      
      it "should parse SELECT * (with spaces in front of the star)" do
        parse_and_eval("SELECT    *").should == Expression::Select.new("*")
      end
      
      it "should parse SELECT * (with spaces at the end of the star)" do
        parse_and_eval("SELECT    *        ").should == Expression::Select.new("*")
      end
      
      it "should not parse SELECT*" do
        parse("SELECT*").should be_nil
      end
      
      it "should parse SELECT column_name" do
        parse_and_eval("SELECT column_name").should == Expression::Select.new("column_name")
      end
      
      it "should parse SELECT column_name1" do
        pending 'todo'
        parse_and_eval("SELECT column_name1").should == Expression::Select.new("column_name1")
      end
      
      it "should parse SELECT my_column_name" do
        parse_and_eval("SELECT my_column_name").should == Expression::Select.new("my_column_name")
      end
      
      it "should parse SELECT table_name.column_name" do
        parse_and_eval("SELECT table_name.column_name").should == Expression::Select.new("table_name.column_name")
      end
      
      it "should parse SELECT `table_name`.column_name" do
        parse_and_eval("SELECT `table_name`.column_name").should == Expression::Select.new("table_name.column_name")
      end
      
      it "should parse SELECT column_one, column_two" do
        parse("SELECT column_one, column_two").should_not be_nil
      end
      
      it "should parse SELECT column_one, column_two" do
        parse_and_eval("SELECT column_one, column_two").should == Expression::Select.new("column_one", "column_two")
      end
      
      it "should parse SELECT table_name.column_one, table_name.column_two" do
        parse_and_eval("SELECT table_name.column_one, `table_name`.column_two").should == Expression::Select.new("table_name.column_one", "table_name.column_two")
      end
      
      it "should parse three columns" do
        parse_and_eval("SELECT column_one, column_two, column_three").should == Expression::Select.new("column_one", "column_two", "column_three")
      end
      
      it "should parse columns with mixed *'s and table names" do
        results = Expression::Select.new("foo.column_one", "bar.*", "baz.column_three")
        parse_and_eval("SELECT foo.column_one, bar.*, baz.column_three").should == results
      end
    end
    
    describe "FROM" do
      it "should parse FROM table_name" do
        parse_and_eval("FROM table_name").should == Expression::From.new("table_name")
      end
      
      it "should parse FROM my_table_name" do
        parse_and_eval("FROM my_table_name").should == Expression::From.new("my_table_name")
      end
      
      it "should parse a quoted table name" do
        parse_and_eval("FROM `my_table_name`").should == Expression::From.new("my_table_name")
      end
      
      it "should parse FROM table_name with spaces between the from and the table_name" do
        parse_and_eval("FROM          table_name").should == Expression::From.new("table_name")
      end
      
      it "should parse two table names" do
        parse_and_eval("FROM table_name_one, table_name_two").should == Expression::From.new("table_name_one", "table_name_two")
      end
      
      it "should parse three table names" do
        result = Expression::From.new("table_one", "table_two", "table_three")
        parse_and_eval("FROM table_one, table_two, table_three").should == result
      end
    end
    
    describe "ORDER BY" do
      it "should order by a column name" do
        result = Expression::OrderBy.new("column")
        parse_and_eval("ORDER BY column").should == result
      end
      
      it "should order by a different name" do
        result = Expression::OrderBy.new("different_col")
        parse_and_eval("ORDER BY different_col").should == result
      end
      
      it "should order by two columns" do
        result = Expression::OrderBy.new("different_col", 'column_two')
        parse_and_eval("ORDER BY different_col, column_two").should == result
      end
      
      it "should allow any number of spaces after the ORDER BY clause" do
        result = Expression::OrderBy.new("different_col", 'column_two')
        parse_and_eval("ORDER BY             different_col, column_two").should == result
      end
      
      it "should not parse ORDER BYcolumn_name" do
        parse("ORDER BYcolumn_name").should be_nil
      end
    end
  end
end
