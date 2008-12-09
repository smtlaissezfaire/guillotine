module Guillotine
  module StatementExecutors
    dir = File.dirname(__FILE__) + "/statement_executors"
    autoload :MultiExecutor, "#{dir}/multi_executor"
  end
end
