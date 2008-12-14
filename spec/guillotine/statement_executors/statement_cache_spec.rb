require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module StatementExecutors
    describe StatementCache do
      before(:each) do
        StatementCache.empty_cache!
      end

      it "should have an empty cache to begin with" do
        StatementCache.cache.should == { }
      end

      it "should add a value to the cache" do
        StatementCache.add(:foo, "bar")
        StatementCache.cache.should == { :foo => "bar" }
      end

      it "should be able to reset the cache" do
        StatementCache.add(:foo, "bar")
        StatementCache.empty_cache!
        StatementCache.cache.should == { }
      end

      describe "adding a key" do
        it "should intern a key given" do
          StatementCache.add("foo", "bar")
          StatementCache.cache.should == { :foo => "bar" }
        end

        it "should return the value" do
          StatementCache.add("foo", "bar").should == "bar"
        end
      end

      describe "add_or_find" do
        before(:each) do
          @user = mock 'user'
        end

        describe "when it is in the cache" do
          it "should find a value in the cache" do
            StatementCache.add("SELECT * FROM users", [@user])
            result = StatementCache.add_or_find "SELECT * FROM users" do
              #...
            end
            result.should == [@user]
          end

          it "should not execute the block if the value is in the cache" do
            block_executed = false

            StatementCache.add("SELECT * FROM users", [@user])
            StatementCache.add_or_find "SELECT * FROM users" do
              block_executed = true
            end

            block_executed.should be_false
          end
        end

        describe "when it isn't in the cache" do
          def lookup
            StatementCache.add_or_find "SELECT * FROM users" do
              [@user]
            end
          end

          it "should return the value given by the block" do
            lookup.should == [@user]
          end

          it "should store the result in the cache" do
            lookup
            StatementCache["SELECT * FROM users"].should == [@user]
          end
        end
      end
    end
  end
end
