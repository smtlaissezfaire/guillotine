module Guillotine
  class SelectExpression < Expression::TopLevelExpression
    include Assertions
    
    def initialize(hash)
      @select = hash[:select]
      @from = hash[:from]
      @where = hash[:where]
      @limit = hash[:limit]
      @order_by = hash[:order_by]
      @query_string = hash[:string]
    end

    attr_reader :select
    attr_reader :from
    attr_reader :where
    attr_reader :limit
    attr_reader :order_by    
    attr_reader :query_string
    
    def inspect
      "#{self.class}: #{query_string}"
    end

    def ==(other)
      assert_each_expression do
        assert_equal self.select,   other.select
        assert_equal self.where,    other.where
        assert_equal self.from,     other.from
        assert_equal self.limit,    other.limit
        assert_equal self.order_by, other.order_by
      end
    end
    
    def call(collection)
      return [] if empty_limit? || collection.empty?
      super
    end
    
    def empty_limit?
      limit && limit.limit == 0
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
  end
end
