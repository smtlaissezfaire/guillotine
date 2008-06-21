module Guillotine
  module Extensions
    module Object
      def object_size
        Marshal.dump(self).size
      rescue TypeError
        nil
      end
    end
  end
end

class Object
  include Guillotine::Extensions::Object
end
