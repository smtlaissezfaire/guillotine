module Guillotine
  module DataStore
    extend Using
    
    using :Schema
    using :Table
    
    with_load_scheme :require do
      using :Database
    end
    
    extend DataStore::Database

    class UnknownTable < StandardError; end
    class TableAlreadyExists < StandardError; end
  end
end
