require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  describe SQLSelectParser do
    include ParserSpecHelper
    
    before :each do
      @parser = SQLSelectParser.new
    end
    
    it "should parse 'SELECT * from events'" do
      parse("SELECT * FROM events").should_not be_nil
    end
    
    it "should not parse 'SELECT * from events' the same as 'SELECT * FROM foo'" do
      first_statement  = "SELECT * FROM events"
      second_statement = "SELECT * FROM foo"
      parse_and_eval(first_statement).should_not == parse_and_eval(second_statement)
      parse_and_eval(second_statement).should_not == parse_and_eval(first_statement)
    end
    
    it "should not parse 'SELECT foo from events' the same as 'SELECT foo, bar FROM events'" do
      first_statement  = "SELECT foo      FROM events"
      second_statement = "SELECT foo, bar FROM events"
      parse_and_eval(first_statement).should_not == parse_and_eval(second_statement)
      parse_and_eval(second_statement).should_not == parse_and_eval(first_statement)
    end

    it "should parse and evaluate 'SELECT * from events'" do
      string = "SELECT * FROM events"
      expression = SelectExpression.new(:select => Expression::Select.new("*"), :from => Expression::From.new("events"))
      parse_and_eval(string).should eql(expression)
    end
    
    it "should have the proper query string" do
      string = "SELECT * FROM events"
      parse_and_eval(string).query_string.should == string
    end

    it "should parse 'SELECT * from events where user = 'foo''" do
      parse("SELECT * FROM events WHERE user = 'foo'").should_not be_nil
    end
    
    it "should parse 'SELECT * from events where user = 'foo'' the same as 'SELECT * FROM events WHERE user = 'bar''" do
      first_statement  = "SELECT * FROM events WHERE user = 'foo'"
      second_statement = "SELECT * FROM events WHERE user = 'bar'"
      parse_and_eval(first_statement).should_not == parse_and_eval(second_statement)
      parse_and_eval(second_statement).should_not == parse_and_eval(first_statement)
    end

    it "should parse and evaluate 'SELECT * from events where user = 'foo''" do
      string = "SELECT * FROM events WHERE user = 'foo'"
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      where  = Expression::Equal.new(:user, "foo")
      expression = SelectExpression.new(:select => select, :from => from, :where => where)
      parse_and_eval(string).should eql(expression)
    end
    
    it "should parse and evaluate SELECT   *    FROM     events     where user = 'foo'" do
      string = "SELECT * FROM events WHERE user = 'foo'"
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      where  = Expression::Equal.new(:user, "foo")
      expression = SelectExpression.new(:select => select, :from => from, :where => where)
      parse_and_eval(string).should eql(expression)
    end
    
    it "should parse_and_eval SELECT * FROM events LIMIT 10" do
      string = "SELECT * FROM events LIMIT 10"
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      limit  = Expression::Limit.new(10)
      expression = SelectExpression.new(:select => select, :from => from, :limit => limit)

      parse_and_eval(string).should eql(expression)
    end
    
    it "should parse_and_eval SELECT * FROM events        LIMIT 10" do
      string = "SELECT * FROM events           LIMIT 10"
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      limit  = Expression::Limit.new(10)
      expression = SelectExpression.new(:select => select, :from => from, :limit => limit)

      parse_and_eval(string).should eql(expression)
    end
    
    it "should not parse_and_eval SELECT * FROM events LIMIT 1 the same as SELECT * FROM events LIMIT 10" do
      first_statement = "SELECT * FROM events LIMIT 1"
      second_statement = "SELECT * FROM events LIMIT 10"
      parse_and_eval(first_statement).should_not == parse_and_eval(second_statement)
      parse_and_eval(second_statement).should_not == parse_and_eval(first_statement)
    end

    it "should parse_and_eval SELECT * FROM events ORDER BY foo" do
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      order_by  = Expression::OrderBy.new(Expression::OrderByPair.new(:foo))
      expression = SelectExpression.new(:select => select, :from => from, :order_by => order_by)

      parse_and_eval("SELECT * FROM events ORDER BY foo").should eql(expression)
    end

    it "should parse_and_eval SELECT * FROM events              ORDER BY foo" do
      string = "SELECT * FROM events ORDER BY foo"
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      order_by  = Expression::OrderBy.new(Expression::OrderByPair.new(:foo))
      expression = SelectExpression.new(:select => select, :from => from, :order_by => order_by)

      parse_and_eval(string).should eql(expression)
    end
    
    it "should not parse_and_eval SELECT * FROM events ORDER BY foo the same as SELECT * FROM events ORDER BY bar" do
      first_statement = "SELECT * FROM events ORDER BY foo"
      second_statement = "SELECT * FROM events ORDER BY bar"
      parse_and_eval(first_statement).should_not == parse_and_eval(second_statement)
      parse_and_eval(second_statement).should_not == parse_and_eval(first_statement)
    end
  end
end
