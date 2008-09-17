module Guillotine
  module TestSupport
    dir = File.dirname(__FILE__) + "/test_support"
    autoload :MysqlOverrider, "#{dir}/mysql_overrider"
    autoload :Connection,     "#{dir}/connection"
    autoload :RSpec,          "#{dir}/rspec"
  end
end
