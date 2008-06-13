require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  
  module ParserSpecHelper
    def parse(string)
      @parser.parse(string)
    end
    
    def parse_and_eval(string, *eval_args)
      parse(string).eval(*eval_args)
    end
  end
  
  describe SQLPrimitivesParser do
    include ParserSpecHelper
    
    before :each do
      @parser = SQLPrimitivesParser.new
    end
    
    describe "number" do
      it "should parse the number 0" do
        parse_and_eval('0').should == 0
      end
      
      it "should parse the number 1" do
        parse_and_eval('1').should == 1
      end
      
      it "should parse multiple numbers" do
        parse_and_eval('123').should == 123
      end
      
      it "should not parse the empty string as a number" do
        lambda { 
          parse_and_eval('')
        }.should raise_error
      end
    end
    
    describe 'string' do
      it "should parse a single char" do
        parse_and_eval('a').should == "a"
      end
      
      it "should parse multitple chars" do
        parse_and_eval("aaaa").should == "aaaa"
      end
      
      it "should parse different chars" do
        parse_and_eval("abcd").should == "abcd"
      end
      
      it "should parse an uppercase char" do
        parse_and_eval("A").should == "A"
      end
      
      it "should parse a combination of uppercase and lowercase chars" do
        parse_and_eval("ABcdEF").should == "ABcdEF"
      end
      
      it "should parse underscores" do
        parse_and_eval("_").should == "_"
      end
    end
    
    describe "backtick string" do
      before(:each) do
        @backtick_string = mock("BacktickString")
        @backtick_class = mock('BacktickStringClass', :new => @backtick_string)
      end
      
      it "should parse a simple string properly" do
        @backtick_class.should_receive(:new).with("`foo`").and_return @backtick_string
        parse_and_eval("`foo`", @backtick_class)
      end
      
      it "should parse a different string properly" do
        @backtick_class.should_receive(:new).with("`foobar`").and_return @backtick_string
        parse_and_eval("`foobar`", @backtick_class).should == @backtick_string
      end
    end
    
    describe "quoted string" do
      it "should use single quotes" do
        parse_and_eval("'foo'").should == "foo"
      end
      
      it "should use double quotes" do
        parse_and_eval("\"foo\"").should == "foo"
      end
      
      it "should not parse if it starts with a single quote, but ends in a double quote" do
        parse("\"foo'").should be_nil
      end
      
      it "should not parse if it starts with a double quote and ends in a single quote" do
        parse("'foo\"").should be_nil
      end
      
      it "should not parse a string which has three double quotes" do
        parse('"foo"bar"').should be_nil
      end
      
      it "should match the empty string with single quotes" do
        parse_and_eval("''").should == ""
      end
      
      it "should match the empty string with double quotes" do
        parse_and_eval('""').should == ""
      end
      
      it "should properly nest single quotes" do
        parse_and_eval("\"foo'bar\"").should == "foo'bar"
      end
      
      it "should properly nest a single double quotes" do
        parse_and_eval("'foo\"bar'").should == "foo\"bar"
      end
      
      it "should properly nest two single double quotes" do
        parse_and_eval("'foo\"bar\"'").should == "foo\"bar\""
      end
    end
    
    describe "booleans" do
      it "should parse 'TRUE' as true" do
        parse_and_eval("TRUE").should be_true
      end
      
      it "should parse 'FALSE' as false" do
        parse_and_eval("FALSE").should be_false
      end
      
      it "should parse '1' as true" do
        pending 'todo'
        parse_and_eval("1").should be_true
      end
      
      it "should parse 'true' as true"
      
      it "should parse 'False' as false"
    end
  end
  
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
    
    describe "LIMIT" do
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
    end
  end
end
