
require "benchmark"
require File.dirname(__FILE__) + "/../spec/guillotine/integration/spec_helper"

SQL_STATEMENT = "SELECT * FROM users LIMIT 10"

class User < ActiveRecord::Base; end

TIMES = 10_000

puts "* With sql statement #{SQL_STATEMENT}, and no data in the users table"

Benchmark.bm do |x|
  x.report "using AR & mysql,     #{TIMES} times" do
    TIMES.times do
      User.find(:all)
    end
  end

  x.report "using AR & guillotine, #{TIMES} times" do
    Guillotine::RSpec.before_all
    Guillotine::RSpec.before_each

    TIMES.times do
      User.find(:all)
    end
  end
end
