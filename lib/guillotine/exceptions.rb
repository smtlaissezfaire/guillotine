module Guillotine
  module Exceptions
    class StandardError < ::StandardError; end
    class TableNotTracked < StandardError; end
    class SQLNotUnderstood < StandardError; end
  end
end
