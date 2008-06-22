module SQLOrderByClause
  include Treetop::Runtime

  def root
    @root || :order_by
  end

  include SQLPrimitives

  include SQLRowSupport

  include SQLHelpers

  module OrderBy0
    def one_or_more_column_names_with_sort
      elements[4]
    end
  end

  module OrderBy1

    def eval
      Guillotine::Expression::OrderBy.new(one_or_more_column_names_with_sort.eval)
    end
  end

  def _nt_order_by
    start_index = index
    if node_cache[:order_by].has_key?(index)
      cached = node_cache[:order_by][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("ORDER", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 5))
      @index += 5
    else
      terminal_parse_failure("ORDER")
      r1 = nil
    end
    s0 << r1
    if r1
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
      s0 << r2
      if r2
        if input.index("BY", index) == index
          r4 = (SyntaxNode).new(input, index...(index + 2))
          @index += 2
        else
          terminal_parse_failure("BY")
          r4 = nil
        end
        s0 << r4
        if r4
          s5, i5 = [], index
          loop do
            r6 = _nt_space
            if r6
              s5 << r6
            else
              break
            end
          end
          if s5.empty?
            self.index = i5
            r5 = nil
          else
            r5 = SyntaxNode.new(input, i5...index, s5)
          end
          s0 << r5
          if r5
            r7 = _nt_one_or_more_column_names_with_sort
            s0 << r7
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(OrderBy0)
      r0.extend(OrderBy1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:order_by][start_index] = r0

    return r0
  end

  module OneOrMoreColumnNamesWithSort0
    def one_column_name_with_sort
      elements[0]
    end

    def one_or_more_column_names_with_sort
      elements[3]
    end
  end

  module OneOrMoreColumnNamesWithSort1
    def eval
      result1, result2 = one_column_name_with_sort.eval, one_or_more_column_names_with_sort.eval
      [result1, result2].flatten
    end
  end

  def _nt_one_or_more_column_names_with_sort
    start_index = index
    if node_cache[:one_or_more_column_names_with_sort].has_key?(index)
      cached = node_cache[:one_or_more_column_names_with_sort][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_one_column_name_with_sort
    s1 << r2
    if r2
      if input.index(",", index) == index
        r3 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure(",")
        r3 = nil
      end
      s1 << r3
      if r3
        s4, i4 = [], index
        loop do
          r5 = _nt_space
          if r5
            s4 << r5
          else
            break
          end
        end
        if s4.empty?
          self.index = i4
          r4 = nil
        else
          r4 = SyntaxNode.new(input, i4...index, s4)
        end
        s1 << r4
        if r4
          r6 = _nt_one_or_more_column_names_with_sort
          s1 << r6
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(OneOrMoreColumnNamesWithSort0)
      r1.extend(OneOrMoreColumnNamesWithSort1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r7 = _nt_one_column_name_with_sort
      if r7
        r0 = r7
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:one_or_more_column_names_with_sort][start_index] = r0

    return r0
  end

  module OneColumnNameWithSort0
    def one_column_name
      elements[0]
    end

    def optional_sort_condition
      elements[1]
    end
  end

  module OneColumnNameWithSort1

    def eval
      column = one_column_name.eval
      if value = optional_sort_condition.eval
        Guillotine::Expression::OrderByPair.new(column, value)
      else
        Guillotine::Expression::OrderByPair.new(column)
      end
    end
  end

  def _nt_one_column_name_with_sort
    start_index = index
    if node_cache[:one_column_name_with_sort].has_key?(index)
      cached = node_cache[:one_column_name_with_sort][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_one_column_name
    s0 << r1
    if r1
      r2 = _nt_optional_sort_condition
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(OneColumnNameWithSort0)
      r0.extend(OneColumnNameWithSort1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:one_column_name_with_sort][start_index] = r0

    return r0
  end

  module OptionalSortCondition0
    def sort_condition
      elements[1]
    end
  end

  module OptionalSortCondition1
    def eval; sort_condition.eval; end
  end

  def _nt_optional_sort_condition
    start_index = index
    if node_cache[:optional_sort_condition].has_key?(index)
      cached = node_cache[:optional_sort_condition][index]
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
      r4 = _nt_sort_condition
      s1 << r4
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(OptionalSortCondition0)
      r1.extend(OptionalSortCondition1)
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

    node_cache[:optional_sort_condition][start_index] = r0

    return r0
  end

  def _nt_sort_condition
    start_index = index
    if node_cache[:sort_condition].has_key?(index)
      cached = node_cache[:sort_condition][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_ascending
    if r1
      r0 = r1
    else
      r2 = _nt_descending
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:sort_condition][start_index] = r0

    return r0
  end

  module Ascending0
    def eval; Guillotine::Expression::OrderBy::ASC; end
  end

  def _nt_ascending
    start_index = index
    if node_cache[:ascending].has_key?(index)
      cached = node_cache[:ascending][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("ASC", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 3))
      r0.extend(Ascending0)
      @index += 3
    else
      terminal_parse_failure("ASC")
      r0 = nil
    end

    node_cache[:ascending][start_index] = r0

    return r0
  end

  module Descending0
    def eval; Guillotine::Expression::OrderBy::DESC; end
  end

  def _nt_descending
    start_index = index
    if node_cache[:descending].has_key?(index)
      cached = node_cache[:descending][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("DESC", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 4))
      r0.extend(Descending0)
      @index += 4
    else
      terminal_parse_failure("DESC")
      r0 = nil
    end

    node_cache[:descending][start_index] = r0

    return r0
  end

end

class SQLOrderByClauseParser < Treetop::Runtime::CompiledParser
  include SQLOrderByClause
end

