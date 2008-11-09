require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLDataTypesParser do
      include ParserSpecHelper
      
      before :each do
        @parser = SQLDataTypesParser.new
      end
      
      it "should parse BIT" do
        parse("BIT").should_not be_nil
      end
      
      it "should parse BIT(1)" do
        parse("BIT(1)").should_not be_nil
      end
      
      it "should parse BIT(10)" do
        parse("BIT(10)").should_not be_nil
      end
      
      #   | TINYINT[(length)] [UNSIGNED] [ZEROFILL]
      #   | SMALLINT[(length)] [UNSIGNED] [ZEROFILL]
      #   | MEDIUMINT[(length)] [UNSIGNED] [ZEROFILL]
      [
       "TINYINT",
       "SMALLINT",
       "INT",
       "INTEGER",
       "BIGINT"
      ].each do |keyword|
        it "should parse #{keyword}" do
          parse("#{keyword}").should_not be_nil
        end
        
        it "should parse #{keyword}(1)" do
          parse("#{keyword}(1)").should_not be_nil
        end
        
        it "should parse #{keyword} UNSIGNED" do
          parse("#{keyword} UNSIGNED").should_not be_nil
        end
        
        it "should parse #{keyword} ZEROFILL" do
          parse("#{keyword} ZEROFILL").should_not be_nil
        end
      end
      
      #   | REAL[(length,decimals)] [UNSIGNED] [ZEROFILL]
      #   | DOUBLE[(length,decimals)] [UNSIGNED] [ZEROFILL]
      #   | FLOAT[(length,decimals)] [UNSIGNED] [ZEROFILL]
      #   | DECIMAL[(length[,decimals])] [UNSIGNED] [ZEROFILL]
      #   | NUMERIC[(length[,decimals])] [UNSIGNED] [ZEROFILL]
      [
       "REAL",
       "DOUBLE",
       "FLOAT",
       "DECIMAL",
       "NUMERIC"
      ].each do |keyword|
        it "should parse #{keyword}" do
          parse("#{keyword}").should_not be_nil
        end
        
        it "should parse #{keyword}(1, 10)" do
          parse("#{keyword} (1, 10)").should_not be_nil
        end
        
        it "should parse #{keyword} UNSIGNED" do
          parse("#{keyword} UNSIGNED").should_not be_nil
        end
        
        it "should parse #{keyword} ZEROFILL" do
          parse("#{keyword} ZEROFILL").should_not be_nil
        end
      end
      
      it "should parse REAL (2, 10)" do
        parse("REAL (2, 10)").should_not be_nil
      end
      
      it "should parse REAL (2, 20)" do
        parse("REAL (2, 10)").should_not be_nil
      end
      
      it "should parse REAL (   10  ,   20   )" do
        parse("REAL (   10  ,   20   )").should_not be_nil
      end
      
      it "should parse INT ( 11 )" do
        parse("INT ( 11 )").should_not be_nil
      end
    end
  end
end
