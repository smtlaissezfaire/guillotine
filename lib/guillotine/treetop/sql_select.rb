module SQLSelect
  include Treetop::Runtime

  def root
    @root || :select_expression
  end

  include SQLRowSupport

  include SQLSelectClause

  include SQLFromClause

  include SQLWhereCondition

  include SQLOrderByClause

  include SQLLimit

  include SQLHelpers

  module SelectExpression0
    def select
      elements[0]
    end

    def from
      elements[1]
    end

    def where_condition_or_empty
      elements[2]
    end

    def limit_condition_or_empty
      elements[3]
    end

    def order_by_condition_or_empty
      elements[4]
    end
  end

  module SelectExpression1
    def eval
      Guillotine::SelectExpression.new({
        :string => self.text_value,

        :select => select.eval,
        :from   => from.eval,
        :where  => where_condition_or_empty.eval,
        :limit  => limit_condition_or_empty.eval,
        :order_by => order_by_condition_or_empty.eval
      })
    end
  end

  def _nt_select_expression
    start_index = index
    if node_cache[:select_expression].has_key?(index)
      cached = node_cache[:select_expression][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_select
    s0 << r1
    if r1
      r2 = _nt_from
      s0 << r2
      if r2
        r3 = _nt_where_condition_or_empty
        s0 << r3
        if r3
          r4 = _nt_limit_condition_or_empty
          s0 << r4
          if r4
            r5 = _nt_order_by_condition_or_empty
            s0 << r5
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SelectExpression0)
      r0.extend(SelectExpression1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:select_expression][start_index] = r0

    return r0
  end

end

class SQLSelectParser < Treetop::Runtime::CompiledParser
  include SQLSelect
end
