require "rubygems"
require "ruby-prof"
require File.dirname(__FILE__) + "/../lib/guillotine"
require 'sqlite3'
require "active_record"

ActiveRecord::Base.establish_connection({ 
  :adapter  => 'mysql', 
  :database => 'guillotine_test',
  :user     => "root"
})
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.column :username, :string
  end
end

class User < ActiveRecord::Base
end

# String.random, taken from FixtureReplacement
class String
  def self.random(length=10)
    chars = ("a".."z").to_a
    string = ""
    1.upto(length) { |i| string << chars[rand(chars.size-1)]}
    return string
  end
end

# setup the table
User.delete_all

def run_benchmark(name)
  require "benchmark"
  
  puts ""
  puts "******** With #{name} ***************************"
  puts ""
  
  Benchmark.bm do |x|
    x.report do
      1000.times do
        User.create!(:username => "smtlaissezfaire")
      end
    end
  end
end

# run_benchmark("Database")

User.delete_all

# Swap out regular method for Guillotine
Guillotine::RSpec.before_all
Guillotine::RSpec.before_each

run_benchmark("Guillotine")
