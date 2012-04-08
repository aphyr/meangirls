class Meangirls::Counter < Meangirls::CRDT
  require 'meangirls/g_counter'

  def ===(other)
    # Can only compare to numerics
    unless other.kind_of? Meangirls::Counter or
      other.kind_of? Numeric
      return false
    end

    # TODO: This gets awkward when we exceed FP integer precision in aggregate
    # over actors.
    if float?
      self.to_f == other.to_f
    else
      self.to_i == other.to_i
    end
  end

  # Returns a copy of this counter, with the local Meangirls node's value
  # incremented by delta.
  def +(delta)
    clone.increment(Meangirls.node, delta)
  end

  def -(delta)
    clone.increment(Meangirls.node, -1 * delta)
  end

  def to_i
    to_f.to_i
  end
end
