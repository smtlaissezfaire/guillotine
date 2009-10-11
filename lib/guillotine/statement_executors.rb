module Guillotine
  module StatementExecutors
    extend Using
    
    using :SingleExecutor
    using :MultiExecutor
    using :StatementCache
  end
end
