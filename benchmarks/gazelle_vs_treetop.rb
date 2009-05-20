require "benchmark"
require File.dirname(__FILE__) + "/../lib/guillotine"

SQL_STATEMENT = "CREATE TABLE foo (bar INT)"

TIMES = 10_000

puts "* With sql statement #{SQL_STATEMENT}"

Benchmark.bmbm do |x|
  treetop = Guillotine::Parser::SQLCreateTableParser.new
  gazelle = Guillotine::Parser::SQLGazelleParser

  x.report "using Treetop" do
    TIMES.times do
      treetop.parse(SQL_STATEMENT)
    end
  end

  x.report "using Gazelle" do
    TIMES.times do
      gazelle.parse(SQL_STATEMENT)
    end
  end
end
