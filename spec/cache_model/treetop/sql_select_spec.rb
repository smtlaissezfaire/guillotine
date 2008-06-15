require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  describe SQLSelectParser do
    include ParserSpecHelper
    
    before :each do
      @parser = SQLSelectParser.new
    end
    
    it "should parse 'SELECT * from events'" do
      parse("SELECT * FROM events").should_not be_nil
    end

    it "should parse and evaluate 'SELECT * from events'" do
      expression = SelectExpression.new(:select => Expression::Select.new("*"), :from => Expression::From.new("events"))
      parse_and_eval("SELECT * FROM events").should eql(expression)
    end

    it "should parse 'SELECT * from events where user = 'foo''" do
      parse("SELECT * FROM events WHERE user = 'foo'").should_not be_nil
    end

    it "should parse and evaluate 'SELECT * from events where user = 'foo''" do
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      where  = Expression::Equal.new(:user, "foo")
      expression = SelectExpression.new(:select => select, :from => from, :where => where)
      parse_and_eval("SELECT * FROM events WHERE user = 'foo'").should eql(expression)
    end
    
    it "should parse and evaluate SELECT   *    FROM     events     where user = 'foo'" do
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      where  = Expression::Equal.new(:user, "foo")
      expression = SelectExpression.new(:select => select, :from => from, :where => where)
      parse_and_eval("SELECT * FROM events WHERE user = 'foo'").should eql(expression)
    end
    
    it "should parse_and_eval SELECT * FROM events LIMIT 10" do
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      limit  = Expression::Limit.new(10)
      expression = SelectExpression.new(:select => select, :from => from, :limit => limit)

      parse_and_eval("SELECT * FROM events LIMIT 10").should eql(expression)
    end
    
    it "should parse_and_eval SELECT * FROM events        LIMIT 10" do
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      limit  = Expression::Limit.new(10)
      expression = SelectExpression.new(:select => select, :from => from, :limit => limit)

      parse_and_eval("SELECT * FROM events           LIMIT 10").should eql(expression)
    end

    it "should parse_and_eval SELECT * FROM events ORDER BY foo" do
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      order_by  = Expression::OrderBy.new("foo")
      expression = SelectExpression.new(:select => select, :from => from, :order_by => order_by)

      parse_and_eval("SELECT * FROM events ORDER BY foo").should eql(expression)
    end

    it "should parse_and_eval SELECT * FROM events              ORDER BY foo" do
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      order_by  = Expression::OrderBy.new("foo")
      expression = SelectExpression.new(:select => select, :from => from, :order_by => order_by)

      parse_and_eval("SELECT * FROM events ORDER BY foo").should eql(expression)
    end
  end
end
