module Guillotine
  module Assertions
    private
    
    def assert_each_expression(&blk)
      callcc do |cc|
        @continuation = cc
        yield
        true
      end
    end
    
    def assert(expression)
      Assertion.new(@continuation).assert(expression)
    end
    
    def assert_equal(expr1, expr2)
      assert(expr1 == expr2)
    end
    
    class Assertion
      def initialize(continuation = nil)
        @continuation = continuation
      end
      
      def assert(expression)
        expression ? true : assert_false
      end
      
    private
      
      def assert_false
        @continuation ? @continuation.call(false) : false
      end
    end
  end
end
