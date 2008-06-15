module CachedModel
  class SelectExpression
    def initialize(hash)
      @initial_hash = hash
      @select = hash[:select]
      @from = hash[:from]
      @where = hash[:where]
      @limit = hash[:limit]
      @order_by = hash[:order_by]
    end

    attr_reader :select
    attr_reader :from
    attr_reader :where
    attr_reader :limit
    attr_reader :order_by    

    def ==(other)
      assert_each_expression do
        assert(self.select == other.select)
        assert self.where  == other.where
        assert self.from   == other.from
        assert self.limit  == other.limit
        assert self.order_by == other.order_by
      end
    end

    # TODO: In the future, eql? and == should not be the
    # same in all cases.  For now, they are aliased, but
    # in the future eql? should be the case in which two queries
    # are parsed in *exactly* the same way, where == should be
    # looser in meaning; The following queries should be ==, but not eql?:
    #
    # SELECT * FROM events WHERE foo = "Scott"
    # SELECT * FROM `events` WHERE foo = 'Scott'
    alias_method :eql?, :==

  protected

    attr_reader :initial_hash
    
  private
    
    def assert_each_expression(&blk)
      yield
      return true
    rescue Assertion::AssertionFailedError
      return false
    end
    
    def assert(expression)
      Assertion.assert(expression)
    end
    
    class Assertion
      class AssertionFailedError < StandardError; end
      
      def self.assert(expression)
        new.assert(expression)
      end
      
      def assert(expression)
        if expression
          return true
        else
          raise Assertion::AssertionFailedError
        end
      end
    end
  end
end
