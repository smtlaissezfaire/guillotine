require "ruby-prof"
require File.dirname(__FILE__) + "/../lib/guillotine"
require 'sqlite3'
require "active_record"

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database  => ':memory:'
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.column :username, :string
    t.column :last_name, :string
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
table = []
10_000.times { 
  hash = { :username => String.random, :last_name => String.random }
  table << hash
  User.create!(hash)
}

first_sort = Guillotine::Expression::OrderByPair.new(:username, :DESC)
second_sort = Guillotine::Expression::OrderByPair.new(:last_name, :ASC)

sorter = Guillotine::Expression::OrderBy.new(first_sort, second_sort)


puts ""
puts "******** With Guillotine ***************************"
puts ""

# run it!
result = RubyProf.profile do
  sorter.call(table)
end

# Print a graph profile to text
printer = RubyProf::GraphPrinter.new(result)
printer.print(STDOUT, 0)

puts ""
puts "******** With Sqlite/rails in memory database ***************************"
puts ""


result = RubyProf.profile do
  User.find(:all, :order => "username DESC, last_name ASC")
end

# Print a graph profile to text
printer = RubyProf::GraphPrinter.new(result)
printer.print(STDOUT, 0)
