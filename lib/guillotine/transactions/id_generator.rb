require 'digest/sha1'

module Guillotine
  module Transactions
    class IdGenerator
      def self.generate
        new.generate
      end
      
      def generate
        our_sha1.intern
      end
      
    private
      
      def our_sha1
        sha1 "#{time} #{rand}"
      end
      
      def time
        Time.now.to_s
      end
      
      def sha1(string)
        Digest::SHA1.hexdigest(string)
      end
    end
  end
end
