module Guillotine
  module Conditions
    class OrCondition < Base
      def call(collection)
        return [] if collection.empty?
        results_of_first_call = first_child.call(collection)
        results_of_first_call | second_child.call(collection)
      end
    end
  end
end
