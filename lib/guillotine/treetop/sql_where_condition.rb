module SQLWhereCondition
  include Treetop::Runtime

  def root
    @root || :where_condition
  end

  include SQLKeyValuePair

  module WhereCondition0
    def where_clause
      elements[2]
    end
  end

  module WhereCondition1
    def eval
      where_clause.eval
    end
  end

  def _nt_where_condition
    start_index = index
    if node_cache[:where_condition].has_key?(index)
      cached = node_cache[:where_condition][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("WHERE", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 5))
      @index += 5
    else
      terminal_parse_failure("WHERE")
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
        r4 = _nt_where_clause
        s0 << r4
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(WhereCondition0)
      r0.extend(WhereCondition1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:where_condition][start_index] = r0

    return r0
  end

  module WhereClause0
    def open_parens
      elements[0]
    end

    def optional_spaces
      elements[1]
    end

    def where_clause
      elements[2]
    end

    def optional_spaces
      elements[3]
    end

    def close_parens
      elements[4]
    end
  end

  module WhereClause1
    def eval
      where_clause.eval
    end
  end

  module WhereClause2
    def clause1
      elements[0]
    end

    def disjunction_or_conjunction_joiner
      elements[2]
    end

    def clause2
      elements[4]
    end
  end

  module WhereClause3
    def eval
      klass = Guillotine::Expression.find_class_for(disjunction_or_conjunction_joiner.eval)
      klass.new(clause1.eval, clause2.eval)
    end
  end

  def _nt_where_clause
    start_index = index
    if node_cache[:where_clause].has_key?(index)
      cached = node_cache[:where_clause][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_open_parens
    s1 << r2
    if r2
      r3 = _nt_optional_spaces
      s1 << r3
      if r3
        r4 = _nt_where_clause
        s1 << r4
        if r4
          r5 = _nt_optional_spaces
          s1 << r5
          if r5
            r6 = _nt_close_parens
            s1 << r6
          end
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(WhereClause0)
      r1.extend(WhereClause1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      i7, s7 = index, []
      r8 = _nt_single_expression_where_clause
      s7 << r8
      if r8
        s9, i9 = [], index
        loop do
          r10 = _nt_space
          if r10
            s9 << r10
          else
            break
          end
        end
        if s9.empty?
          self.index = i9
          r9 = nil
        else
          r9 = SyntaxNode.new(input, i9...index, s9)
        end
        s7 << r9
        if r9
          r11 = _nt_disjunction_or_conjunction_joiner
          s7 << r11
          if r11
            s12, i12 = [], index
            loop do
              r13 = _nt_space
              if r13
                s12 << r13
              else
                break
              end
            end
            if s12.empty?
              self.index = i12
              r12 = nil
            else
              r12 = SyntaxNode.new(input, i12...index, s12)
            end
            s7 << r12
            if r12
              r14 = _nt_where_clause
              s7 << r14
            end
          end
        end
      end
      if s7.last
        r7 = (SyntaxNode).new(input, i7...index, s7)
        r7.extend(WhereClause2)
        r7.extend(WhereClause3)
      else
        self.index = i7
        r7 = nil
      end
      if r7
        r0 = r7
      else
        r15 = _nt_single_expression_where_clause
        if r15
          r0 = r15
        else
          self.index = i0
          r0 = nil
        end
      end
    end

    node_cache[:where_clause][start_index] = r0

    return r0
  end

  def _nt_disjunction_or_conjunction_joiner
    start_index = index
    if node_cache[:disjunction_or_conjunction_joiner].has_key?(index)
      cached = node_cache[:disjunction_or_conjunction_joiner][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_and
    if r1
      r0 = r1
    else
      r2 = _nt_or
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:disjunction_or_conjunction_joiner][start_index] = r0

    return r0
  end

  module And0
    def eval; :AND; end
  end

  def _nt_and
    start_index = index
    if node_cache[:and].has_key?(index)
      cached = node_cache[:and][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("AND", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 3))
      r0.extend(And0)
      @index += 3
    else
      terminal_parse_failure("AND")
      r0 = nil
    end

    node_cache[:and][start_index] = r0

    return r0
  end

  module Or0
    def eval; :OR; end
  end

  def _nt_or
    start_index = index
    if node_cache[:or].has_key?(index)
      cached = node_cache[:or][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("OR", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 2))
      r0.extend(Or0)
      @index += 2
    else
      terminal_parse_failure("OR")
      r0 = nil
    end

    node_cache[:or][start_index] = r0

    return r0
  end

  def _nt_open_parens
    start_index = index
    if node_cache[:open_parens].has_key?(index)
      cached = node_cache[:open_parens][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("(", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("(")
      r0 = nil
    end

    node_cache[:open_parens][start_index] = r0

    return r0
  end

  def _nt_close_parens
    start_index = index
    if node_cache[:close_parens].has_key?(index)
      cached = node_cache[:close_parens][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(")", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure(")")
      r0 = nil
    end

    node_cache[:close_parens][start_index] = r0

    return r0
  end

  def _nt_single_expression_where_clause
    start_index = index
    if node_cache[:single_expression_where_clause].has_key?(index)
      cached = node_cache[:single_expression_where_clause][index]
      @index = cached.interval.end if cached
      return cached
    end

    r0 = _nt_key_value_pair

    node_cache[:single_expression_where_clause][start_index] = r0

    return r0
  end

end

class SQLWhereConditionParser < Treetop::Runtime::CompiledParser
  include SQLWhereCondition
end
