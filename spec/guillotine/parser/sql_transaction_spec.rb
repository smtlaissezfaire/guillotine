require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe SQLTransactionParser do 
      include ParserSpecHelper     
      
      before :each do
        @parser = SQLTransactionParser.new
      end
      
      it "should parse 'START TRANSACTION'" do
        parse("START TRANSACTION").should_not be_nil
      end
      
      it "should parse 'START   TRANSACTION'" do
        parse("START     TRANSACTION").should_not be_nil
      end
      
      it "should parse 'START TRANSACTION WITH CONSISTENT SNAPSHOT'" do
        parse("START TRANSACTION WITH CONSISTENT SNAPSHOT").should_not be_nil
      end
      
      it "should parse 'START TRANSACTION WITH CONSISTENT SNAPSHOT' with spaces" do
        parse("START TRANSACTION             WITH           CONSISTENT                 SNAPSHOT").should_not be_nil
      end
      
      it "should parse 'BEGIN'" do
        parse("BEGIN").should_not be_nil
      end
      
      it "should parse 'BEGIN WORK'" do
        parse("BEGIN WORK").should_not be_nil
      end
      
      it "should parse 'COMMIT'" do
        parse("COMMIT").should_not be_nil
      end
      
      it "should parse COMMIT WORK" do
        parse("COMMIT WORK").should_not be_nil        
      end
      
      it "should parse COMMIT AND CHAIN" do
        parse("COMMIT AND CHAIN").should_not be_nil
      end
      
      it "should parse COMMIT    AND    CHAIN" do
        parse("COMMIT    AND    CHAIN").should_not be_nil
      end
      
      it "should parse COMMIT AND NO CHAIN" do
        parse("COMMIT AND NO CHAIN").should_not be_nil
      end
      
      it "should parse COMMIT RELEASE" do
        parse("COMMIT RELEASE").should_not be_nil
      end
      
      it "should parse COMMIT NO RELEASE" do
        parse("COMMIT NO RELEASE").should_not be_nil
      end
      
      it "should parse ROLLBACK" do
        parse("ROLLBACK").should_not be_nil
      end
      
      it "should parse ROLLBACK WORK" do
        parse("ROLLBACK WORK").should_not be_nil
      end
      
      it "should parse ROLLBACK AND CHAIN" do
        parse("ROLLBACK AND CHAIN").should_not be_nil
      end
      
      it "should parse ROLLBACK    AND    CHAIN" do
        parse("ROLLBACK    AND    CHAIN").should_not be_nil
      end
      
      it "should parse ROLLBACK AND NO CHAIN" do
        parse("ROLLBACK AND NO CHAIN").should_not be_nil
      end
      
      it "should parse ROLLBACK RELEASE" do
        parse("ROLLBACK RELEASE").should_not be_nil
      end
      
      it "should parse ROLLBACK NO RELEASE" do
        parse("ROLLBACK NO RELEASE").should_not be_nil
      end
    end
  end
end
