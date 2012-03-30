class Meangirls::LWWSet < Meangirls::Set
  require 'time'

  class Pair
    attr_accessor :add, :remove
    def initialize(add, remove)
      @add = add
      @remove = remove
    end

    def ==(o)
      o.kind_of? Pair and
      add == o.add and
      remove == o.remove
    end

    def exists_a?
      return false unless @add
      return true unless @remove
      @add >= @remove
    end
    
    def exists_r?
      return false unless @add
      return true unless @remove
      @add > @remove
    end

    def inspect
      "(#{add.inspect}, #{remove.inspect})"
    end

    # Merge with another pair, taking the largest add and largest delete stamp.
    def merge(other)
      unless other
        return clone
      end

      Pair.new(
        [add, other.add].compact.max, 
        [remove, other.remove].compact.max
      )
    end
    alias | merge
  end

  def self.biases
    ['a', 'r']
  end

  attr_accessor :e
  attr_accessor :bias
  def initialize(hash = nil)
    @e = {}
    @bias = 'a'

    if hash
      raise ArgumentError, "hash must contain e" unless hash['e']
      @bias = hash['bias'] if hash['bias']
      hash['e'].each do |list|
        element, add, delete = list
        @e[element] = Pair.new(add, delete).merge(@e[element])
      end    
    end
  end

  # Inserts e into the set with a default generated timestamp.
  # Your clocks ARE synchronized, right? WRONG!
  def <<(e)
    add(e, timestamp)
  end

  # Strict equality: both adds and removes are equal.
  def ==(other)
    other.kind_of? self.class and
    e == other.e
  end

  # Add e, with an optional timestamp.
  def add(e, time = timestamp)
    merge_element! e, Pair.new(time, nil)
    self
  end

  def as_json
    {
      'type' => type,
      'e' => @e.map { |e, pair|
        [e, pair.add, pair.remove]
      }
    }
  end

  def clone
    c = super
    c.e = e.clone
    c
  end

  # Delete e from self, with optional timestamp.
  def delete(e, time = timestamp)
    merge_element! e, Pair.new(nil, time)
    e
  end

  # Is e an element of the set?
  def include?(e)
    return false unless pair = @e[e]
    case bias
      when 'a'
        pair.exists_a?
      when 'r'
        pair.exists_r?
      else
        raise RuntimeError, "unsupported bias #{bias.inspect}"
     end
  end

  # Merge with another lww-set
  def merge(other)
    unless other.kind_of? self.class
      raise ArgumentError, "other must be a #{self.class}"
    end

    c = clone
    other.e.each do |element, pair|
      c.merge_element!(element, pair)
    end
    c
  end

  # Mutates self to update the value for e with the given pair.
  def merge_element!(e, pair)
    if cur = @e[e]
      @e[e] = cur | pair
    else
      @e[e] = pair
    end
  end

  def to_set
    case bias
      when 'a'
        @e.inject(Set.new) do |s, l|
          element, pair = l
          s << element if pair.exists_a?
          s
        end
      when 'r'
        @e.inject(Set.new) do |s, l|
          element, pair = l
          s << element if pair.exists_r?
          s
        end
    end
  end

  # Default timestamps are the present time in UTC as ISO 8601 strings, WITH a
  # seconds fraction guaranteed to be unique and monotonically increasing for
  # all use of Meangirls.
  def timestamp
    Meangirls.timestamp
  end

  def type
    'lww-set'
  end
end
