module SQLKeyValuePair
  include Treetop::Runtime

  def root
    @root || :key_value_pair
  end

  include SQLPrimitives

  module KeyValuePair0
    def string
      elements[0]
    end

    def optional_spaces
      elements[1]
    end

    def joiner_or_null
      elements[2]
    end
  end

  module KeyValuePair1
    def eval
      results = joiner_or_null.eval
      klass = Guillotine::Expression.find_class_for(results[:joiner])
      if value = results[:value]
        klass.new(string.eval.to_sym, results[:value])
      else
        klass.new(string.eval.to_sym)
      end
    end
  end

  def _nt_key_value_pair
    start_index = index
    if node_cache[:key_value_pair].has_key?(index)
      cached = node_cache[:key_value_pair][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_string
    s0 << r1
    if r1
      r2 = _nt_optional_spaces
      s0 << r2
      if r2
        r3 = _nt_joiner_or_null
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(KeyValuePair0)
      r0.extend(KeyValuePair1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:key_value_pair][start_index] = r0

    return r0
  end

  def _nt_joiner_or_null
    start_index = index
    if node_cache[:joiner_or_null].has_key?(index)
      cached = node_cache[:joiner_or_null][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_a_null
    if r1
      r0 = r1
    else
      r2 = _nt_joiner_with_value
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:joiner_or_null][start_index] = r0

    return r0
  end

  def _nt_a_null
    start_index = index
    if node_cache[:a_null].has_key?(index)
      cached = node_cache[:a_null][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_is_not_null
    if r1
      r0 = r1
    else
      r2 = _nt_is_null
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:a_null][start_index] = r0

    return r0
  end

  module IsNotNull0
  end

  module IsNotNull1
    def eval
      { :joiner => :"IS NOT NULL" }
    end
  end

  def _nt_is_not_null
    start_index = index
    if node_cache[:is_not_null].has_key?(index)
      cached = node_cache[:is_not_null][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("IS", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure("IS")
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
        if input.index("NOT", index) == index
          r4 = (SyntaxNode).new(input, index...(index + 3))
          @index += 3
        else
          terminal_parse_failure("NOT")
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
            if input.index("NULL", index) == index
              r7 = (SyntaxNode).new(input, index...(index + 4))
              @index += 4
            else
              terminal_parse_failure("NULL")
              r7 = nil
            end
            s0 << r7
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(IsNotNull0)
      r0.extend(IsNotNull1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:is_not_null][start_index] = r0

    return r0
  end

  module IsNull0
  end

  module IsNull1
    def eval
      { :joiner => :"IS NULL" }
    end
  end

  def _nt_is_null
    start_index = index
    if node_cache[:is_null].has_key?(index)
      cached = node_cache[:is_null][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index("IS", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure("IS")
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
        if input.index("NULL", index) == index
          r4 = (SyntaxNode).new(input, index...(index + 4))
          @index += 4
        else
          terminal_parse_failure("NULL")
          r4 = nil
        end
        s0 << r4
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(IsNull0)
      r0.extend(IsNull1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:is_null][start_index] = r0

    return r0
  end

  module JoinerWithValue0
    def condition_joiner
      elements[0]
    end

    def optional_spaces
      elements[1]
    end

    def primitive
      elements[2]
    end
  end

  module JoinerWithValue1
    def eval
      { 
        :joiner => condition_joiner.eval,
        :value => primitive.eval
      }
    end
  end

  def _nt_joiner_with_value
    start_index = index
    if node_cache[:joiner_with_value].has_key?(index)
      cached = node_cache[:joiner_with_value][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_condition_joiner
    s0 << r1
    if r1
      r2 = _nt_optional_spaces
      s0 << r2
      if r2
        r3 = _nt_primitive
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(JoinerWithValue0)
      r0.extend(JoinerWithValue1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:joiner_with_value][start_index] = r0

    return r0
  end

  def _nt_condition_joiner
    start_index = index
    if node_cache[:condition_joiner].has_key?(index)
      cached = node_cache[:condition_joiner][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_greater_than_or_equal
    if r1
      r0 = r1
    else
      r2 = _nt_less_than_or_equal
      if r2
        r0 = r2
      else
        r3 = _nt_equals
        if r3
          r0 = r3
        else
          r4 = _nt_not_equals
          if r4
            r0 = r4
          else
            r5 = _nt_less_than
            if r5
              r0 = r5
            else
              r6 = _nt_greater_than
              if r6
                r0 = r6
              else
                self.index = i0
                r0 = nil
              end
            end
          end
        end
      end
    end

    node_cache[:condition_joiner][start_index] = r0

    return r0
  end

  module LessThanOrEqual0
    def eval;   :<=;   end
  end

  def _nt_less_than_or_equal
    start_index = index
    if node_cache[:less_than_or_equal].has_key?(index)
      cached = node_cache[:less_than_or_equal][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("<=", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 2))
      r0.extend(LessThanOrEqual0)
      @index += 2
    else
      terminal_parse_failure("<=")
      r0 = nil
    end

    node_cache[:less_than_or_equal][start_index] = r0

    return r0
  end

  module GreaterThanOrEqual0
    def eval;   :>=    end
  end

  def _nt_greater_than_or_equal
    start_index = index
    if node_cache[:greater_than_or_equal].has_key?(index)
      cached = node_cache[:greater_than_or_equal][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(">=", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 2))
      r0.extend(GreaterThanOrEqual0)
      @index += 2
    else
      terminal_parse_failure(">=")
      r0 = nil
    end

    node_cache[:greater_than_or_equal][start_index] = r0

    return r0
  end

  module LessThan0
    def eval;   :<     end
  end

  def _nt_less_than
    start_index = index
    if node_cache[:less_than].has_key?(index)
      cached = node_cache[:less_than][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("<", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      r0.extend(LessThan0)
      @index += 1
    else
      terminal_parse_failure("<")
      r0 = nil
    end

    node_cache[:less_than][start_index] = r0

    return r0
  end

  module GreaterThan0
    def eval;   :>     end
  end

  def _nt_greater_than
    start_index = index
    if node_cache[:greater_than].has_key?(index)
      cached = node_cache[:greater_than][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(">", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      r0.extend(GreaterThan0)
      @index += 1
    else
      terminal_parse_failure(">")
      r0 = nil
    end

    node_cache[:greater_than][start_index] = r0

    return r0
  end

  module NotEquals0
    def eval;   :"!="   end
  end

  def _nt_not_equals
    start_index = index
    if node_cache[:not_equals].has_key?(index)
      cached = node_cache[:not_equals][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("!=", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 2))
      r0.extend(NotEquals0)
      @index += 2
    else
      terminal_parse_failure("!=")
      r0 = nil
    end

    node_cache[:not_equals][start_index] = r0

    return r0
  end

  module Equals0
    def eval;  :"="    end
  end

  def _nt_equals
    start_index = index
    if node_cache[:equals].has_key?(index)
      cached = node_cache[:equals][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index("=", index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      r0.extend(Equals0)
      @index += 1
    else
      terminal_parse_failure("=")
      r0 = nil
    end

    node_cache[:equals][start_index] = r0

    return r0
  end

end

class SQLKeyValuePairParser < Treetop::Runtime::CompiledParser
  include SQLKeyValuePair
end
