module CachedModel
  class SelectExpression
    def initialize(hash)
      @initial_hash = hash
      @select = hash[:select]
      @from = hash[:from]
      @where = hash[:where] || nil
    end

    attr_reader :select
    attr_reader :from
    attr_reader :where

    def ==(other)
      other.select == self.select
      other.from   == self.from
      other.where  == self.where
    end

  protected

    attr_reader :initial_hash

  end
end
