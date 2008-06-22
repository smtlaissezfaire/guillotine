module SQLDelete
  include Treetop::Runtime

  def root
    @root || :delete
  end

  include SQLRowSupport

  include SQLWhereCondition

  include SQLOrderByClause

  include SQLLimit

  include SQLHelpers

  def _nt_delete
    start_index = index
    if node_cache[:delete].has_key?(index)
      cached = node_cache[:delete][index]
      @index = cached.interval.end if cached
      return cached
    end

    r0 = _nt_single_table_delete

    node_cache[:delete][start_index] = r0

    return r0
  end

  module SingleTableDelete0
    def common_delete_clause
      elements[0]
    end

    def table_name
      elements[1]
    end

    def where_condition_or_empty
      elements[2]
    end

    def order_by_condition_or_empty
      elements[3]
    end

    def limit_condition_or_empty
      elements[4]
    end
  end

  module SingleTableDelete1
    def eval
      Guillotine::Expression::DeleteStatement.new(table_name.eval, where_condition_or_empty.eval, order_by_condition_or_empty.eval, limit_condition_or_empty.eval)
    end
  end

  def _nt_single_table_delete
    start_index = index
    if node_cache[:single_table_delete].has_key?(index)
      cached = node_cache[:single_table_delete][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_common_delete_clause
    s0 << r1
    if r1
      r2 = _nt_table_name
      s0 << r2
      if r2
        r3 = _nt_where_condition_or_empty
        s0 << r3
        if r3
          r4 = _nt_order_by_condition_or_empty
          s0 << r4
          if r4
            r5 = _nt_limit_condition_or_empty
            s0 << r5
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SingleTableDelete0)
      r0.extend(SingleTableDelete1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:single_table_delete][start_index] = r0

    return r0
  end

  module CommonDeleteClause0
    def optional_delete_directives
      elements[2]
    end

  end

  def _nt_common_delete_clause
    start_index = index
    if node_cache[:common_delete_clause].has_key?(index)
      cached = node_cache[:common_delete_clause][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("DELETE", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 6))
      @index += 6
    else
      terminal_parse_failure("DELETE")
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
        r4 = _nt_optional_delete_directives
        s0 << r4
        if r4
          if input.index("FROM", index) == index
            r5 = (SyntaxNode).new(input, index...(index + 4))
            @index += 4
          else
            terminal_parse_failure("FROM")
            r5 = nil
          end
          s0 << r5
          if r5
            s6, i6 = [], index
            loop do
              r7 = _nt_space
              if r7
                s6 << r7
              else
                break
              end
            end
            if s6.empty?
              self.index = i6
              r6 = nil
            else
              r6 = SyntaxNode.new(input, i6...index, s6)
            end
            s0 << r6
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(CommonDeleteClause0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:common_delete_clause][start_index] = r0

    return r0
  end

  module OptionalDeleteDirectives0
    def optional_low_priority
      elements[0]
    end

    def optional_quick
      elements[1]
    end

    def optional_ignore
      elements[2]
    end
  end

  def _nt_optional_delete_directives
    start_index = index
    if node_cache[:optional_delete_directives].has_key?(index)
      cached = node_cache[:optional_delete_directives][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_optional_low_priority
    s0 << r1
    if r1
      r2 = _nt_optional_quick
      s0 << r2
      if r2
        r3 = _nt_optional_ignore
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(OptionalDeleteDirectives0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:optional_delete_directives][start_index] = r0

    return r0
  end

  def _nt_optional_low_priority
    start_index = index
    if node_cache[:optional_low_priority].has_key?(index)
      cached = node_cache[:optional_low_priority][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_low_priority
    if r1
      r0 = r1
    else
      r2 = _nt_empty_string
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:optional_low_priority][start_index] = r0

    return r0
  end

  def _nt_optional_quick
    start_index = index
    if node_cache[:optional_quick].has_key?(index)
      cached = node_cache[:optional_quick][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_quick
    if r1
      r0 = r1
    else
      r2 = _nt_empty_string
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:optional_quick][start_index] = r0

    return r0
  end

  def _nt_optional_ignore
    start_index = index
    if node_cache[:optional_ignore].has_key?(index)
      cached = node_cache[:optional_ignore][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_ignore
    if r1
      r0 = r1
    else
      r2 = _nt_empty_string
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:optional_ignore][start_index] = r0

    return r0
  end

  module Ignore0
  end

  def _nt_ignore
    start_index = index
    if node_cache[:ignore].has_key?(index)
      cached = node_cache[:ignore][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("IGNORE", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 6))
      @index += 6
    else
      terminal_parse_failure("IGNORE")
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
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Ignore0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:ignore][start_index] = r0

    return r0
  end

  module Quick0
  end

  def _nt_quick
    start_index = index
    if node_cache[:quick].has_key?(index)
      cached = node_cache[:quick][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("QUICK", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 5))
      @index += 5
    else
      terminal_parse_failure("QUICK")
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
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Quick0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:quick][start_index] = r0

    return r0
  end

  module LowPriority0
  end

  def _nt_low_priority
    start_index = index
    if node_cache[:low_priority].has_key?(index)
      cached = node_cache[:low_priority][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("LOW_PRIORITY", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 12))
      @index += 12
    else
      terminal_parse_failure("LOW_PRIORITY")
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
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(LowPriority0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:low_priority][start_index] = r0

    return r0
  end

end

class SQLDeleteParser < Treetop::Runtime::CompiledParser
  include SQLDelete
end
