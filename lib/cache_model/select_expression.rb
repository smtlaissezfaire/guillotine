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
      other.select == self.select
      other.from   == self.from
      other.where  == self.where
      other.limit  == self.limit
    end

  protected

    attr_reader :initial_hash

  end
end
