module SQLRowSupport
  include Treetop::Runtime

  def root
    @root || :one_or_more_table_names
  end

  include SQLPrimitives

  module OneOrMoreTableNames0
    def table_name
      elements[0]
    end

    def one_or_more_table_names
      elements[3]
    end
  end

  module OneOrMoreTableNames1
    def eval
      [table_name.eval, one_or_more_table_names.eval]
    end
  end

  def _nt_one_or_more_table_names
    start_index = index
    if node_cache[:one_or_more_table_names].has_key?(index)
      cached = node_cache[:one_or_more_table_names][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_table_name
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
          r6 = _nt_one_or_more_table_names
          s1 << r6
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(OneOrMoreTableNames0)
      r1.extend(OneOrMoreTableNames1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r7 = _nt_table_name
      if r7
        r0 = r7
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:one_or_more_table_names][start_index] = r0

    return r0
  end

  module OneOrMoreColumnNamesWithSort0
    def one_column_name_with_sort
      elements[0]
    end

    def one_or_more_column_names
      elements[3]
    end
  end

  module OneOrMoreColumnNamesWithSort1
    def eval
      result1, result2 = one_column_name.eval, one_or_more_column_names.eval
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
          r6 = _nt_one_or_more_column_names
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

  module OneOrMoreColumnNames0
    def one_column_name
      elements[0]
    end

    def one_or_more_column_names
      elements[3]
    end
  end

  module OneOrMoreColumnNames1
    def eval
      result1, result2 = one_column_name.eval, one_or_more_column_names.eval
      [result1, result2].flatten
    end
  end

  def _nt_one_or_more_column_names
    start_index = index
    if node_cache[:one_or_more_column_names].has_key?(index)
      cached = node_cache[:one_or_more_column_names][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_one_column_name
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
          r6 = _nt_one_or_more_column_names
          s1 << r6
        end
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(OneOrMoreColumnNames0)
      r1.extend(OneOrMoreColumnNames1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r7 = _nt_one_column_name
      if r7
        r0 = r7
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:one_or_more_column_names][start_index] = r0

    return r0
  end

  module OneColumnName0
    def table_name
      elements[0]
    end

    def dot
      elements[1]
    end

    def column_name
      elements[2]
    end
  end

  module OneColumnName1
    def eval
      table_name.eval + dot.eval + column_name.eval
    end
  end

  def _nt_one_column_name
    start_index = index
    if node_cache[:one_column_name].has_key?(index)
      cached = node_cache[:one_column_name][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_table_name
    s1 << r2
    if r2
      r3 = _nt_dot
      s1 << r3
      if r3
        r4 = _nt_column_name
        s1 << r4
      end
    end
    if s1.last
      r1 = (SyntaxNode).new(input, i1...index, s1)
      r1.extend(OneColumnName0)
      r1.extend(OneColumnName1)
    else
      self.index = i1
      r1 = nil
    end
    if r1
      r0 = r1
    else
      r5 = _nt_column_name
      if r5
        r0 = r5
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:one_column_name][start_index] = r0

    return r0
  end

  def _nt_column_name
    start_index = index
    if node_cache[:column_name].has_key?(index)
      cached = node_cache[:column_name][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_string
    if r1
      r0 = r1
    else
      r2 = _nt_all_columns
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:column_name][start_index] = r0

    return r0
  end

  module TableName0
    def eval 
      Guillotine::BackTickString.new(text_value).value
    end
  end

  def _nt_table_name
    start_index = index
    if node_cache[:table_name].has_key?(index)
      cached = node_cache[:table_name][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_backtick_string
    r1.extend(TableName0)
    if r1
      r0 = r1
    else
      r2 = _nt_string
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:table_name][start_index] = r0

    return r0
  end

  module Dot0
    def eval; "."; end
  end

  def _nt_dot
    start_index = index
    if node_cache[:dot].has_key?(index)
      cached = node_cache[:dot][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(".", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      r0.extend(Dot0)
      @index += 1
    else
      terminal_parse_failure(".")
      r0 = nil
    end

    node_cache[:dot][start_index] = r0

    return r0
  end

  module AllColumns0
    def eval; "*"; end
  end

  def _nt_all_columns
    start_index = index
    if node_cache[:all_columns].has_key?(index)
      cached = node_cache[:all_columns][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("*", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      r0.extend(AllColumns0)
      @index += 1
    else
      terminal_parse_failure("*")
      r0 = nil
    end

    node_cache[:all_columns][start_index] = r0

    return r0
  end

end

class SQLRowSupportParser < Treetop::Runtime::CompiledParser
  include SQLRowSupport
end
