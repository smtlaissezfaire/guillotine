
require "benchmark"
require File.dirname(__FILE__) + "/../lib/guillotine"

SQL_STATEMENT = "INSERT INTO `foo` (`col_one`, `col_two`) VALUES (1, 'smtlaissezfaire')"

Benchmark.bmbm do |x|
  x.report "pre-parsing and regular parsing" do
    2000.times do
      Guillotine.execute(SQL_STATEMENT)
    end
  end
  
  x.report "pre parser" do
    2000.times do
      Guillotine::PreParser.parse(SQL_STATEMENT)
    end
  end
end
