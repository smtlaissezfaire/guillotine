require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Transactions
    describe IdGenerator do
      before :each do
        @generator = IdGenerator.new
        @now = Time.now
      end
      
      it "should generate an ID based on the time" do
        Time.should_receive(:now).and_return @now
        @generator.generate
      end
      
      it "should generate an ID as a symbol" do
        @generator.generate.should be_a_kind_of(Symbol)
      end
      
      it "should be a SHA1 hash, 40 chars long" do
        @generator.generate.to_s.length.should == 40
      end
      
      it "should never be the same (every transaction should have it's own id)" do
        generated_list = []
        
        10.times do
          generation = @generator.generate
          generated_list.should_not include(generation)
          generated_list << generation
        end
      end
      
      describe "class method generator" do
        before :each do
          @id_generator_mock = mock IdGenerator
          IdGenerator.stub!(:new).and_return @id_generator_mock
          @id_generator_mock.stub!(:generate).and_return "4dc9dcf72fca7fa9b86c4c4d600c4ca776fd3fe7".intern
        end
        
        it "should call IdGenerator.new" do
          IdGenerator.should_receive(:new).and_return @id_generator_mock
          IdGenerator.generate
        end
        
        it "should call generate" do
          @id_generator_mock.should_receive(:generate).and_return "4dc9dcf72fca7fa9b86c4c4d600c4ca776fd3fe7".intern
          IdGenerator.generate
        end
      end
    end
  end
end
