require File.dirname(__FILE__) + "/../spec_helper"

# Bug Report: 
# OR is not working correctly:
#
# >> Guillotine.parse("SELECT * FROM events WHERE username = 'bob' OR id = 2").where.call([{ :id => 1, :username => "bob"}, {:id => 2, :username => "jill"}])
# => [{:username=>"bob", :id=>1}]
# >> Guillotine.parse("SELECT * FROM events WHERE id = 2 OR username = 'bob'").where.call([{ :id => 1, :username => "bob"}, {:id => 2, :username => "jill"}])
# => [{:username=>"jill", :id=>2}]

module Guillotine
  describe "parse regression" do
    before :each do
      @records = [{ :id => 1, :username => "bob"}, {:id => 2, :username => "jill"}]
    end
    
    it "should query 'SELECT * FROM events WHERE username = 'bob' OR id = 2' appropriately" do
      query = "SELECT * FROM events WHERE username = 'bob' OR id = 2"
      Guillotine.parse(query).where.call(@records).should == @records
    end
  end
end
