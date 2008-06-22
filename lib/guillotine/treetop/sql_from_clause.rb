module SQLFromClause
  include Treetop::Runtime

  def root
    @root || :from
  end

  include SQLPrimitives

  include SQLRowSupport

  module From0
    def one_or_more_table_names
      elements[2]
    end
  end

  module From1
    def eval
      Guillotine::Expression::From.new(one_or_more_table_names.eval)
    end
  end

  def _nt_from
    start_index = index
    if node_cache[:from].has_key?(index)
      cached = node_cache[:from][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("FROM", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 4))
      @index += 4
    else
      terminal_parse_failure("FROM")
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
        r4 = _nt_one_or_more_table_names
        s0 << r4
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(From0)
      r0.extend(From1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:from][start_index] = r0

    return r0
  end

end

class SQLFromClauseParser < Treetop::Runtime::CompiledParser
  include SQLFromClause
end
