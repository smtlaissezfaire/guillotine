module Guillotine
  module StatementExecutors
    dir = File.dirname(__FILE__) + "/statement_executors"

    autoload :SingleExecutor, "#{dir}/single_executor"
    autoload :MultiExecutor,  "#{dir}/multi_executor"
    autoload :StatementCache, "#{dir}/statement_cache"
  end
end
