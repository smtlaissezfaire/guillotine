module SQLTruncate
  include Treetop::Runtime

  def root
    @root || :truncate
  end

  include SQLRowSupport

  module Truncate0
  end

  module Truncate1
    def table_name
      elements[3]
    end
  end

  module Truncate2
    def eval
      Guillotine::Expression::Truncate.new(table_name.eval)
    end
  end

  def _nt_truncate
    start_index = index
    if node_cache[:truncate].has_key?(index)
      cached = node_cache[:truncate][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("TRUNCATE", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 8))
      @index += 8
    else
      terminal_parse_failure("TRUNCATE")
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
        i5, s5 = index, []
        if input.index("TABLE", index) == index
          r6 = (SyntaxNode).new(input, index...(index + 5))
          @index += 5
        else
          terminal_parse_failure("TABLE")
          r6 = nil
        end
        s5 << r6
        if r6
          s7, i7 = [], index
          loop do
            r8 = _nt_space
            if r8
              s7 << r8
            else
              break
            end
          end
          if s7.empty?
            self.index = i7
            r7 = nil
          else
            r7 = SyntaxNode.new(input, i7...index, s7)
          end
          s5 << r7
        end
        if s5.last
          r5 = (SyntaxNode).new(input, i5...index, s5)
          r5.extend(Truncate0)
        else
          self.index = i5
          r5 = nil
        end
        if r5
          r4 = r5
        else
          r4 = SyntaxNode.new(input, index...index)
        end
        s0 << r4
        if r4
          r9 = _nt_table_name
          s0 << r9
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Truncate1)
      r0.extend(Truncate2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:truncate][start_index] = r0

    return r0
  end

end

class SQLTruncateParser < Treetop::Runtime::CompiledParser
  include SQLTruncate
end
