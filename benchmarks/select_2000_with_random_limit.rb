
require "benchmark"
require File.dirname(__FILE__) + "/../spec/guillotine/integration/spec_helper"

class User < ActiveRecord::Base; end

TIMES = 10_000

Benchmark.bm do |x|
  x.report "using AR & mysql,     #{TIMES} times" do
    1.upto(TIMES) do |num|
      User.find(:all, :limit => num)
    end
  end

  x.report "using AR & guillotine, #{TIMES} times" do
    Guillotine::RSpec.before_all
    Guillotine::RSpec.before_each

    1.upto(TIMES) do |num|
      User.find(:all, :limit => num)
    end
  end
end
