require File.dirname(__FILE__) + "/../spec_helper"

describe Guillotine do
  describe "requiring a file" do
    before :each do
      @guillotine = Guillotine
      @super_class = mock('Kernel')
      @super_class.stub!(:require)
    end
    
    describe 'when the file is present as a .rb file' do
      it "should require the file if it is found a .rb extension" do
        @super_class.should_receive(:require).with("a_file").and_return true
        Guillotine.require("a_file", @super_class)
      end
      
      it "should require the file with the correct filename" do
        @super_class.should_receive(:require).with("the_proper_filename").and_return true
        Guillotine.require("the_proper_filename", @super_class)
      end
      
      it "should return true when Kernel.require returns true" do
        @super_class.stub!(:require).and_return true
        Guillotine.require("the_proper_filename", @super_class).should be_true
      end
      
      it "should return false when Kernel.require returns false" do
        @super_class.stub!(:require).and_return false
        Guillotine.require("the_proper_filename", @super_class).should be_false
      end
    end
    
    describe "when the file is present as a .rb file, but is present as a .treetop file" do
      before :each do
        @super_class.stub!(:require).and_raise LoadError
        Treetop.stub!(:load)
      end
      
      it "should load the treetop file with Treetop.load" do
        Treetop.should_receive(:load).with("a_file")
        Guillotine.require("a_file", @super_class)
      end
      
      it "should load the treetop file with the correct name" do
        Treetop.should_receive(:load).with("the_proper_filename")
        Guillotine.require("the_proper_filename", @super_class)
      end
      
      it "should return true when treetop.load returns true" do
        Treetop.stub!(:load).with("the_proper_filename").and_return true
        Guillotine.require("the_proper_filename", @super_class).should be_true
      end
      
      it "should return false when treetop.load returns true" do
        Treetop.stub!(:load).with("the_proper_filename").and_return false
        Guillotine.require("the_proper_filename", @super_class).should be_false
      end
    end
    
    describe "when the .treetop file is not present" do
      before :each do
        @super_class.stub!(:require).and_raise(LoadError)
        Treetop.stub!(:load).and_raise(Errno::ENOENT)
      end
      
      it "should raise a LoadError with an appropriate message" do
        lambda { 
          Guillotine.require("does_not_exist")
        }.should raise_error(LoadError, "Could not load the file 'does_not_exist' with a rb, treetop, or tt extension")
      end
    end
  end
end
