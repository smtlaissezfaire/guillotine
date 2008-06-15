module CachedModel
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
  include CachedModel::Extensions::Object
end
