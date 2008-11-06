require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Parser
    describe ShowParser do
      include ParserSpecHelper

      before :each do
        @parser = ShowParser.new
      end

      it "should parse 'SHOW TABLES'" do
        parse("SHOW TABLES").should_not be_nil
      end
      
      def datastore
        Guillotine::DataStore
      end
      
      it "should return the table names" do
        datastore.should_receive(:table_names).and_return []
        parse_and_eval("SHOW TABLES")
      end
    end
  end
end
