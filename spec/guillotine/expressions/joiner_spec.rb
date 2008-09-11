require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe Equal do
      it "should have to_sql as 'a = b'" do
        Equal.new(:a, :b).to_sql.should == "a = b"
      end
    end
    
    describe LessThan do
      it "should have to_sql as 'a < b'" do
        LessThan.new(:a, :b).to_sql.should == "a < b"
      end
    end
    
    describe GreaterThan do
      it "should have to_sql as 'a > b'" do
        GreaterThan.new(:a, :b).to_sql.should == "a > b"
      end
    end

    describe GreaterThanOrEqualTo do
      it "should have a >= b as to sql" do
        GreaterThanOrEqualTo.new(:a, :b).to_sql.should == "a >= b"
      end
    end

    describe LessThan do
      it "should have to_sql as a > b" do
        LessThan.new(:a, :b).to_sql.should == "a < b"
      end
    end

    describe LessThanOrEqualTo do
      it "should have to_sql as a <= b" do
        LessThanOrEqualTo.new(:a, :b).to_sql.should == "a <= b"
      end
    end

    describe NotEqual do
      it "should have to_sql as a != b" do
        NotEqual.new(:a, :b).to_sql.should == "a != b"
      end
    end

    describe IsNull do
      it "should have to_sql as a > b" do
        IsNull.new(:a).to_sql.should == "a IS NULL"
      end
    end
    
    describe IsNotNull do
      it "should have to_sql as a > b" do
        IsNotNull.new(:a).to_sql.should == "a IS NOT NULL"
      end
    end
  end
end
