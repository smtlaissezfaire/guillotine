module Guillotine
  module Shell
    extend Using
    
    using :Main
    using :Command
    using :OutputFormatter
    
    def self.start
      Main.do
    end
  end
end
