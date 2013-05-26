class Meangirls::GCounter < Meangirls::Counter
  attr_accessor :e
  def initialize(hash = nil)
    @e = {}

    if hash
      raise ArgumentError, 'hash must contain e' unless hash['e']
      @e = hash['e']
    end
  end

  # Strict equality: all actor counts match.
  def ==(other)
    other.kind_of? self.class and
    @e == other.e
  end

  def as_json
    {
      'type' => type,
      'e' => @e
    }
  end

  # Adds delta to this counter, as tracked by node. Returns self.
  def increment(node = 1, delta = 1)
    if delta < 0
      raise ArgumentError, "Can't decrement a GCounter"
    end

    if @e[node]
      @e[node] += delta
    else
      @e[node] = delta
    end

    self
  end

  # Adds delta to this counter, using the current Meangirls node ID.
  def +(delta)
    increment Meangirls.node, delta
  end

  def clone
    c = super
    c.e = @e.clone
  end

  # Are any sums floating-point?
  def float?
    @e.any? do |k, v|
      v.is_a? Float
    end
  end

  # Merge with another GCounter and return the merged copy.
  def merge(other)
    unless other.kind_of? self.class
      raise ArgumentErrornew, "other must be a #{self.class}"
    end

    copy = clone
    @e.each do |k, v|
      if existing = copy.e[k]
        copy.e[k] = v if v > existing
      else
        copy.e[k] = v
      end
    end

    copy
  end

  def to_f
    @e.values.inject(&:+) || 0.0
  end

  def type
    'g-counter'
  end
end
