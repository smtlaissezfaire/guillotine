module Guillotine
  class PreParser
    def self.parse(string)
      new.parse(string)
    end
    
    def parse(string)
      string = remove_extra_chars(string)
#       Guillotine::Parser::QuotesParser.new.parse(string).eval
    end
    
  private
    
    def remove_extra_chars(string)
      string.strip.gsub("\r", "").squeeze("\n").gsub("\n", " ")
    end
  end
end
