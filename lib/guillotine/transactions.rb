module Guillotine
  module Transactions
    extend Using
    
    using :IdGenerator
    using :Store
    using :Transaction
  end
end
