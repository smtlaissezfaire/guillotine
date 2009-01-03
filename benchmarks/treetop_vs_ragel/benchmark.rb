require "rubygems"
require "treetop"
require "benchmark"

NUM_TIMES = 10_000
SQL_QUERY = "SELECT * FROM foo"

module Compilation
  def dir
    File.dirname(__FILE__)
  end

  def compile_ragel
    `ragel -R #{dir}/ragel_sql.rl`
  end

  def compile_treetop
    `tt #{dir}/treetop_sql.treetop`
  end
end

extend Compilation

compile_ragel
compile_treetop

require "treetop_sql"
require "ragel_sql"


Benchmark.bmbm do |x|
  x.report "treetop parser" do
    NUM_TIMES.times do 
      TreetopSQLParser.new.parse(SQL_QUERY)
    end
  end

  x.report "ragel parser" do
    NUM_TIMES.times do
      RagelSQLParser.new.parse(SQL_QUERY)
    end
  end
end

