class Meangirls::TwoPhaseSet < Meangirls::Set
  def self.biases
    ['r']
  end
  
  attr_accessor :a, :r
  def initialize(hash = nil)
    if hash
      raise ArgumentError, "hash must contain a" unless hash['a']
      raise ArgumentError, "hash must contain r" unless hash['r']

      @a = Set.new hash['a']
      @r = Set.new hash['r']
    else
      # Empty set
      @a = Set.new
      @r = Set.new
    end
  end

  # Inserts e into the set. Raises ReinsertNotAllowed if e was previously
  # deleted.
  def <<(e)
    if @r.include? e
      raise Meangirls::ReinsertNotAllowed
    end

    @a << e
    self
  end

  # Strict equality: both adds and removes for both 2p-sets are equal.
  def ==(other)
    other.kind_of? self.class and
    a == other.a and
    r == other.r
  end

  def as_json
    {
      'type' => type,
      'a' => a.to_a,
      'r' => r.to_a 
    }
  end

  def bias
    'r'
  end

  def clone
    c = super
    c.a = a.clone
    c.r = r.clone
    c
  end

  # Deletes e from self. Raises DeleteNotAllowed if e does not presently
  # exist.
  def delete(e)
    unless @a.include? e
      raise Meangirls::DeleteNotAllowed
    end
    @r << e
    e
  end
 
  # Merge with another 2p-set.
  def merge(other)
    unless other.kind_of? self.class
      raise ArgumentError, "other must be a #{self.class}"
    end

    self.class.new(
      'a' => (a | other.a),
      'r' => (r | other.r)
    )
  end

  def include?(e)
    @a.include? e and not @r.include? e
  end

  def to_set
    @a - @r
  end

  def type
    '2p-set'
  end
end
