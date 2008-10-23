module Guillotine
  class PreParser
    def self.parse(string)
      new.parse(string)
    end
    
    def parse(string)
      if string = quote_parse(remove_extra_chars(string))
        string.eval.join(" ")
      else
        nil
      end
    end
    
  private
    
    def quote_parse(string)
      Guillotine::Parser::QuotesParser.new.parse(string)
    end
    
    def remove_extra_chars(string)
      string.strip.gsub("\r", "").squeeze("\n").gsub("\n", " ")
    end
  end
end
