module SQLHelpers
  include Treetop::Runtime

  def root
    @root || :where_condition_or_empty
  end

  module WhereConditionOrEmpty0
    def where_condition
      elements[1]
    end
  end

  module WhereConditionOrEmpty1
    def eval
      where_condition.eval
    end
  end

  def _nt_where_condition_or_empty
    start_index = index
    if node_cache[:where_condition_or_empty].has_key?(index)
      cached = node_cache[:where_condition_or_empty][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    s2, i2 = [], index
    loop do
      r3 = _nt_space
      if r3
        s2 << r3
      else
        break
      end
    end
    if s2.empty?
      self.index = i2
      r2 = nil
    else
      r2 = SyntaxNode.new(input, i2...index, s2)
    end
    s1 << r2
    if r2
      r4 = _nt_where_condition
      s1 << r4
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(WhereConditionOrEmpty0)
      r1.extend(WhereConditionOrEmpty1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r5 = _nt_empty_string
      if r5
        r0 = r5
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:where_condition_or_empty][start_index] = r0

    return r0
  end

  module LimitConditionOrEmpty0
    def limit
      elements[1]
    end
  end

  module LimitConditionOrEmpty1
    def eval; limit.eval; end
  end

  def _nt_limit_condition_or_empty
    start_index = index
    if node_cache[:limit_condition_or_empty].has_key?(index)
      cached = node_cache[:limit_condition_or_empty][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    s2, i2 = [], index
    loop do
      r3 = _nt_space
      if r3
        s2 << r3
      else
        break
      end
    end
    if s2.empty?
      self.index = i2
      r2 = nil
    else
      r2 = SyntaxNode.new(input, i2...index, s2)
    end
    s1 << r2
    if r2
      r4 = _nt_limit
      s1 << r4
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(LimitConditionOrEmpty0)
      r1.extend(LimitConditionOrEmpty1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r5 = _nt_empty_string
      if r5
        r0 = r5
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:limit_condition_or_empty][start_index] = r0

    return r0
  end

  module OrderByConditionOrEmpty0
    def order_by
      elements[1]
    end
  end

  module OrderByConditionOrEmpty1
    def eval; order_by.eval; end
  end

  def _nt_order_by_condition_or_empty
    start_index = index
    if node_cache[:order_by_condition_or_empty].has_key?(index)
      cached = node_cache[:order_by_condition_or_empty][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    s2, i2 = [], index
    loop do
      r3 = _nt_space
      if r3
        s2 << r3
      else
        break
      end
    end
    if s2.empty?
      self.index = i2
      r2 = nil
    else
      r2 = SyntaxNode.new(input, i2...index, s2)
    end
    s1 << r2
    if r2
      r4 = _nt_order_by
      s1 << r4
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(OrderByConditionOrEmpty0)
      r1.extend(OrderByConditionOrEmpty1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r5 = _nt_empty_string
      if r5
        r0 = r5
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:order_by_condition_or_empty][start_index] = r0

    return r0
  end

  module EmptyString0
    def eval; nil; end
  end

  def _nt_empty_string
    start_index = index
    if node_cache[:empty_string].has_key?(index)
      cached = node_cache[:empty_string][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('', index) == index
      r0 = (SyntaxNode).new(input, index...(index + 0))
      r0.extend(EmptyString0)
      @index += 0
    else
      terminal_parse_failure('')
      r0 = nil
    end

    node_cache[:empty_string][start_index] = r0

    return r0
  end

end

class SQLHelpersParser < Treetop::Runtime::CompiledParser
  include SQLHelpers
end
