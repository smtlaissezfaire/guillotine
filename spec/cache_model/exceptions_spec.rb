require File.dirname(__FILE__) + "/../spec_helper"

module CacheModel
  describe "exceptions" do
    describe "finding an element with :first and an :include" do
      it "should pass the argumetns onto the regular find" do
        @target.should_receive(:find).with(:first, :include => :foo)
        @finder.find(:first, :include => :foo)
      end
    end
   
    describe "finding an element with :all and an :include" do
      it "should pass the argumetns onto the regular find" do
        @target.should_receive(:find).with(:all, :include => :foo)
        @finder.find(:all, :include => :foo)
      end
    end
  end
end
