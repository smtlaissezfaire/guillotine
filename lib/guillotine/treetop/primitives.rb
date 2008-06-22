module SQLPrimitives
  include Treetop::Runtime

  def root
    @root || :primitive
  end

  def _nt_primitive
    start_index = index
    if node_cache[:primitive].has_key?(index)
      cached = node_cache[:primitive][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_boolean
    if r1
      r0 = r1
    else
      r2 = _nt_quoted_string
      if r2
        r0 = r2
      else
        r3 = _nt_backtick_string
        if r3
          r0 = r3
        else
          r4 = _nt_number
          if r4
            r0 = r4
          else
            r5 = _nt_string
            if r5
              r0 = r5
            else
              self.index = i0
              r0 = nil
            end
          end
        end
      end
    end

    node_cache[:primitive][start_index] = r0

    return r0
  end

  def _nt_space
    start_index = index
    if node_cache[:space].has_key?(index)
      cached = node_cache[:space][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(" ", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure(" ")
      r0 = nil
    end

    node_cache[:space][start_index] = r0

    return r0
  end

  def _nt_optional_spaces
    start_index = index
    if node_cache[:optional_spaces].has_key?(index)
      cached = node_cache[:optional_spaces][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      r1 = _nt_space
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = SyntaxNode.new(input, i0...index, s0)

    node_cache[:optional_spaces][start_index] = r0

    return r0
  end

  def _nt_boolean
    start_index = index
    if node_cache[:boolean].has_key?(index)
      cached = node_cache[:boolean][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_true
    if r1
      r0 = r1
    else
      r2 = _nt_false
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:boolean][start_index] = r0

    return r0
  end

  module True0
    def eval
      true
    end
  end

  def _nt_true
    start_index = index
    if node_cache[:true].has_key?(index)
      cached = node_cache[:true][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("TRUE", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 4))
      r0.extend(True0)
      @index += 4
    else
      terminal_parse_failure("TRUE")
      r0 = nil
    end

    node_cache[:true][start_index] = r0

    return r0
  end

  module False0
    def eval
      false
    end
  end

  def _nt_false
    start_index = index
    if node_cache[:false].has_key?(index)
      cached = node_cache[:false][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("FALSE", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 5))
      r0.extend(False0)
      @index += 5
    else
      terminal_parse_failure("FALSE")
      r0 = nil
    end

    node_cache[:false][start_index] = r0

    return r0
  end

  def _nt_quoted_string
    start_index = index
    if node_cache[:quoted_string].has_key?(index)
      cached = node_cache[:quoted_string][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_single_quoted_string
    if r1
      r0 = r1
    else
      r2 = _nt_double_quoted_string
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:quoted_string][start_index] = r0

    return r0
  end

  module SingleQuotedString0
    def single_quote
      elements[0]
    end

    def single_quote
      elements[2]
    end
  end

  module SingleQuotedString1
    def eval
      instance_eval text_value
    end
  end

  def _nt_single_quoted_string
    start_index = index
    if node_cache[:single_quoted_string].has_key?(index)
      cached = node_cache[:single_quoted_string][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_single_quote
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3 = index
        r4 = _nt_string_chars
        if r4
          r3 = r4
        else
          r5 = _nt_double_quote
          if r5
            r3 = r5
          else
            self.index = i3
            r3 = nil
          end
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        r6 = _nt_single_quote
        s0 << r6
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(SingleQuotedString0)
      r0.extend(SingleQuotedString1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:single_quoted_string][start_index] = r0

    return r0
  end

  def _nt_single_quote
    start_index = index
    if node_cache[:single_quote].has_key?(index)
      cached = node_cache[:single_quote][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("'", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("'")
      r0 = nil
    end

    node_cache[:single_quote][start_index] = r0

    return r0
  end

  module DoubleQuotedString0
    def double_quote
      elements[0]
    end

    def double_quote
      elements[2]
    end
  end

  module DoubleQuotedString1
    def eval
      instance_eval text_value
    end
  end

  def _nt_double_quoted_string
    start_index = index
    if node_cache[:double_quoted_string].has_key?(index)
      cached = node_cache[:double_quoted_string][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_double_quote
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3 = index
        r4 = _nt_string_chars
        if r4
          r3 = r4
        else
          r5 = _nt_single_quote
          if r5
            r3 = r5
          else
            self.index = i3
            r3 = nil
          end
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        r6 = _nt_double_quote
        s0 << r6
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(DoubleQuotedString0)
      r0.extend(DoubleQuotedString1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:double_quoted_string][start_index] = r0

    return r0
  end

  def _nt_double_quote
    start_index = index
    if node_cache[:double_quote].has_key?(index)
      cached = node_cache[:double_quote][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('"', index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('"')
      r0 = nil
    end

    node_cache[:double_quote][start_index] = r0

    return r0
  end

  module BacktickString0
    def string
      elements[1]
    end

  end

  module BacktickString1
    def eval(backtick_string_class=Guillotine::BackTickString)
      backtick_string_class.new(text_value)
    end
  end

  def _nt_backtick_string
    start_index = index
    if node_cache[:backtick_string].has_key?(index)
      cached = node_cache[:backtick_string][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("`", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("`")
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_string
      s0 << r2
      if r2
        if input.index("`", index) == index
          r3 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("`")
          r3 = nil
        end
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(BacktickString0)
      r0.extend(BacktickString1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:backtick_string][start_index] = r0

    return r0
  end

  module String0
    def eval
      text_value
    end
  end

  def _nt_string
    start_index = index
    if node_cache[:string].has_key?(index)
      cached = node_cache[:string][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      r1 = _nt_string_chars
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = SyntaxNode.new(input, i0...index, s0)
      r0.extend(String0)
    end

    node_cache[:string][start_index] = r0

    return r0
  end

  def _nt_string_chars
    start_index = index
    if node_cache[:string_chars].has_key?(index)
      cached = node_cache[:string_chars][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(Regexp.new('[a-zA-Z_]'), index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:string_chars][start_index] = r0

    return r0
  end

  def _nt_number
    start_index = index
    if node_cache[:number].has_key?(index)
      cached = node_cache[:number][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_float
    if r1
      r0 = r1
    else
      r2 = _nt_integer
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:number][start_index] = r0

    return r0
  end

  module Integer0
    def eval
      text_value.to_i
    end
  end

  def _nt_integer
    start_index = index
    if node_cache[:integer].has_key?(index)
      cached = node_cache[:integer][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[0-9]'), index) == index
        r1 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = SyntaxNode.new(input, i0...index, s0)
      r0.extend(Integer0)
    end

    node_cache[:integer][start_index] = r0

    return r0
  end

  module Float0
    def integer
      elements[0]
    end

    def integer
      elements[2]
    end
  end

  module Float1
    def eval
      text_value.to_f
    end
  end

  def _nt_float
    start_index = index
    if node_cache[:float].has_key?(index)
      cached = node_cache[:float][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_integer
    s0 << r1
    if r1
      if input.index(".", index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure(".")
        r2 = nil
      end
      s0 << r2
      if r2
        r3 = _nt_integer
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Float0)
      r0.extend(Float1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:float][start_index] = r0

    return r0
  end

end

class SQLPrimitivesParser < Treetop::Runtime::CompiledParser
  include SQLPrimitives
end
