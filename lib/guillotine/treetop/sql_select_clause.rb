module SQLSelectClause
  include Treetop::Runtime

  def root
    @root || :select
  end

  include SQLPrimitives

  include SQLRowSupport

  module Select0
    def one_or_more_column_names
      elements[2]
    end

    def optional_spaces
      elements[3]
    end
  end

  module Select1

    def eval
      result = one_or_more_column_names.eval
      if result.kind_of?(Array)
        Guillotine::Expression::Select.new(*result)
      else
        Guillotine::Expression::Select.new(result)
      end
    end
  end

  def _nt_select
    start_index = index
    if node_cache[:select].has_key?(index)
      cached = node_cache[:select][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("SELECT", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 6))
      @index += 6
    else
      terminal_parse_failure("SELECT")
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
        r4 = _nt_one_or_more_column_names
        s0 << r4
        if r4
          r5 = _nt_optional_spaces
          s0 << r5
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Select0)
      r0.extend(Select1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:select][start_index] = r0

    return r0
  end

end

class SQLSelectClauseParser < Treetop::Runtime::CompiledParser
  include SQLSelectClause
end
