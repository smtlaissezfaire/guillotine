module Guillotine
  module Extensions
    module Object
      def object_size
        Marshal.dump(self).size
      rescue TypeError
        nil
      end
      
      def guillotine_cache(hash={ }, &blk)
        raise LocalJumpError, "no block given" if blk.nil?
        Guillotine::TimedCache.new(hash, blk)
      end
    end
  end
end

class Object
  include Guillotine::Extensions::Object
end
