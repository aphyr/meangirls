class Meangirls::Set < Meangirls::CRDT
  require 'meangirls/two_phase_set'

  include Enumerable

  # Add all elements of other to a copy of self.
  def |(other)
    other.inject(clone) do |copy, e|
      copy << e
    end
  end

  # Return a copy of self where [all elements not present in other] have been
  # deleted.
  def &(other)
    (to_set - other.to_set).inject(clone) do |copy, e|
      copy.delete e
      copy
    end
  end

  # Add all elements of other to a copy of self.
  def +(other)
    other.inject(clone) do |copy, e|
      copy << e
    end
  end

  # Remove all elements of other from a copy of self.
  def -(other)
    other.inject(clone) do |copy, e|
      copy.delete e
      copy
    end
  end

  # Loose equality: present elements of each set are equal
  def ===(other)
    to_set == other.to_set
  end

  # Iterate over all present elements
  def each(&block)
    to_set.each(&block)
  end

  # Are there no elements present?
  def empty?
    size == 0
  end

  # How many elements are present in the set?
  def size
    to_set.size
  end

  # Convert to an array  
  def to_a
    to_set.to_a
  end
end
