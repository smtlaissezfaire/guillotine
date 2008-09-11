require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe Base do
      it "should have to_sql raise a NotImplementedError" do
        lambda { 
          Base.new(:key, :value).to_sql
        }.should raise_error(NotImplementedError, "Subclasses of Guillotine::Expression::Base must implement #to_sql")
      end
    end
  end
end
