module CacheModel
  describe "finding by id" do
    describe "with an id in the cache" do
      before :each do
        @target = Person
        @finder = CachedModel.new(@target)
        @person = Person.create!
      end
      
      after :each do
        begin
          Person.destroy_all
        rescue
          nil
        end
      end

      before :each do
        @finder.find(:all)
      end
      
      it "should grab the record out of the cache" do
        @finder.find(@person.id).should == @person
      end
    end
  end
end
