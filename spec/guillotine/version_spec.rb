require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe Version do
    it "should be at 0.0.1" do
      Guillotine::Version::VERSION.should == "0.0.1"
    end
  end
end
