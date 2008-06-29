module Guillotine
  module Transactions
    dir = File.dirname(__FILE__) + "/transactions"
    
    autoload :IdGenerator,   "#{dir}/id_generator"
    autoload :Store,         "#{dir}/store"
    autoload :Transaction,   "#{dir}/transaction"
  end
end
