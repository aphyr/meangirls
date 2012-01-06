class Meangirls::ORSet < Meangirls::Set
  Pair = Struct :adds, :removes
  
  def self.biases
    ['a']
  end

  attr_accessor :e
  def initialize(hash = nil)
    @e = {}

    if hash
      raise ArgumentError, 'hash must contain e' unless hash['e']
      hash['e'].each do |list|
        element, adds, removes = list
        merge_internal! element, Pair.new(adds, removes)
      end 
    end
  end

  # Inserts e into the set.
  def <<(e)
    add e
  end

  # Strict equality: all adds/removes match for every element.
  # TODO: slow
  def ==(other)
    other.kind_of? self.class and
    (@e.keys | other.e.keys).all? do |e, pair|
      a = @e[e] and b = other[e] and
      uaeq(a.adds, b.adds) and
      uaeq(a.removes, b.removes)
    end
  end

  # Inserts e into the set. Tag will be randomly generated if not given.
  def add(e, tag = Meangirls.tag)
    pair = (@e[e] ||= Pair.new)
    pair.adds |= tag
  end

  def as_json
    {
      'type' => type,
      'e' => @e.map do |e, pair|
        [e, pair.adds, pair.deletes]
      end
    }
  end

  def bias
    'a'
  end

  # UGH defensive copying
  def clone
    c = super
    @e.each do |e, pair|
      c.merge_internal! e, pair.clone
    end
    c
  end

  # Deletes e from self by cancelling all known tags.
  # Returns nil if no changes, e otherwise.
  def delete(e)
    pair = @e[e] or return
    new = pair.adds - pair.deletes
    return if new.empty?
    pair.deletes += new
    e
  end

  # Merge with another OR-Set
  def merge(other)
    unless other.kind_of? self.class
      raise ArgumentError, "other must be a #{self.class}"
    end

    copy = clone
    @e.each do |e, pair|
      copy.merge_internal! e, pair
    end
    other.e.each do |e, pair|
      copy.merge_internal! e, pair
    end
  end

  # Updates self with new adds and removes for an element.
  def merge_internal!(element, pair)
    if (a,r) = @e[element]
      a |= pair.adds
      r |= pair.removes
    else
      @e[element] = pair
    end
  end
  
  # Unordered array equality
  # TODO: slow
  def uaeq(a, b)
    (a - b).empty? and (b - a).empty?
  end
end
