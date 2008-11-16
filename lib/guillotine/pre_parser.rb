module Guillotine
  class PreParser
    def self.parse(*args)
      new.parse(*args)
    end
    
    def parse(string, upcase=true)
      string = quote_parse(remove_extra_chars(string), upcase)
      string ? string : nil
    end
    
  private
    
    def quote_parse(string, upcase)
      Guillotine::Parser::QuotesParser.new.parse(string, upcase)
    end
    
    def remove_extra_chars(string)
      string.strip.gsub("\r", "").squeeze("\n").gsub("\n", " ")
    end
  end
end
