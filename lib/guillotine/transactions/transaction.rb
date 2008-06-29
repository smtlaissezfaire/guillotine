module Guillotine
  module Transactions
    class Transaction
      def initialize
        Store.register(self)
      end
    end
  end
end
