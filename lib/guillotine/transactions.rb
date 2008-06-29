
module Guillotine
  module Transactions
    dir = File.dirname(__FILE__) + "/transactions"
    autoload :IdGenerator,   "#{dir}/id_generator"
  end
end

