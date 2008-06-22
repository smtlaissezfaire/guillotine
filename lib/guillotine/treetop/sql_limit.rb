module SQLLimit
  include Treetop::Runtime

  def root
    @root || :limit
  end

  include SQLPrimitives

  module Limit0
    def number
      elements[2]
    end
  end

  module Limit1
    def eval; Guillotine::Expression::Limit.new(number.eval); end
  end

  def _nt_limit
    start_index = index
    if node_cache[:limit].has_key?(index)
      cached = node_cache[:limit][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("LIMIT", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 5))
      @index += 5
    else
      terminal_parse_failure("LIMIT")
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
        r4 = _nt_number
        s0 << r4
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Limit0)
      r0.extend(Limit1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:limit][start_index] = r0

    return r0
  end

end

class SQLLimitParser < Treetop::Runtime::CompiledParser
  include SQLLimit
end
