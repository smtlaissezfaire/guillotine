
require "rubygems"
require "using"

Using.default_load_scheme = :autoload

module Guillotine
  extend Using
  
  with_load_scheme :require do
    using :extensions
  end

  using :Assertions
  using :DataStore
  using :PreParser
  using :Parser
  using :Conditions
  using :Keywords
  using :Expressions
  using :TestSupport
  using :RSpec
  using :RakeTasks
  using :Shell
  using :StatementExecutors
  using :Transactions
  using :TestSupport
  using :Version
  
  class << self
    def execute(string)
      Guillotine::StatementExecutors::MultiExecutor.new(string).execute
    end
    
    def parse(string)
      Guillotine::StatementExecutors::MultiExecutor.new(string).parse
    end
  end
end
