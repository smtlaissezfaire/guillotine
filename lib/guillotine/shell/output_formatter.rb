module Guillotine
  module Shell
    class OutputFormatter
      def self.format(obj)
        new.format(obj)
      end
      
      def format(obj)
        obj.to_s
      end
    end
  end
end
