module Guillotine
  module TestSupport
    extend Using
    
    using :MysqlOverrider
    using :Connection
    using :RSpec
  end
end
