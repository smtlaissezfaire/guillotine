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
      self.select == other.select &&
      self.where  == other.where &&
      self.from   == other.from &&
      self.limit  == other.limit &&
      self.order_by == other.order_by
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

  end
end
