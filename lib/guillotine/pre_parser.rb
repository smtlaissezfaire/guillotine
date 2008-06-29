module Guillotine
  class PreParser
    def self.parse(string)
      new.parse(string)
    end
    
    def parse(string)
      string.strip.gsub("\r", "").squeeze("\n").gsub("\n", " ")
    end
  end
end
