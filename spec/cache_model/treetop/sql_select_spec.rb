require File.dirname(__FILE__) + "/../../spec_helper"

module CachedModel
  describe SQLSelectParser do
    include ParserSpecHelper
    
    before :each do
      @parser = SQLSelectParser.new
    end

    it "should parse 'SELECT * from events'" do
      pending 'todo'
      expression = SelectExpression.new(:select => Expression::Select.new("*"), :from => Expression::From.new("events"))
      parse_and_eval("SELECT * FROM events").should == expression
    end

    it "should parse 'SELECT * from events where user = 'foo''" do
      parse("SELECT * FROM events WHERE user = 'foo'").should_not be_nil
    end

    it "should parse 'SELECT * from events where user = 'foo''" do
      select = Expression::Select.new("*")
      from   = Expression::From.new("events")
      where  = Expression::Equal.new(:user, "foo")
      expression = SelectExpression.new(:select => select, :from => from, :where => where)
      parse_and_eval("SELECT * FROM events WHERE user = 'foo'").should == expression
    end
  end
end
