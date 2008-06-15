module CachedModel
  class PreParser
    def parse(string)
      string.strip.gsub("\r", "").squeeze("\n").gsub("\n", " ")
    end
  end
end
