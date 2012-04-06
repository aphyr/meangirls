shared :prob do
  COUNT ||= 10000

  require 'pp'
  def serialize(crdt)
    crdt.to_json
  end

  def deserialize(text)
    Meangirls.parse JSON.parse text
  end

  # Serialize then deserialize CRDT.
  def roundtrip(crdt)
    deserialize serialize crdt
  end

  # Takes a CRDT and returns n copies.
  def split(crdt, n = rand(10))
    n.times.map do
      roundtrip crdt
    end
  end

  # Merge n CRDTs together.
  def merge(crdts)
    crdts.inject(&:merge)
  end

  # Generate a random operation on a CRDT.
  def operation
    op = if rand > 0.5
        :add
      else
        :delete
      end
    [op, rand(10)]
  end

  # A sequence of operations on a CRDT.
  def operations
    rand(5).times.map do
      operation
    end
  end

  # Apply the given operations to this CRDT.
  def apply(ops, crdt)
    ops.inject(crdt) do |c, op|
      begin
        c.send *op
      rescue Meangirls::DeleteNotAllowed
      rescue Meangirls::ReinsertNotAllowed
      end
      c
    end
  end

  # Split, apply operations, merge. 
  def splurge(input, operations)
    splits = split(input, operations.size).map.with_index do |c, i|
      apply operations[i], c
    end
    merged = merge splits
    [input, splits, merged]
  end

  # Attempts to generate failing sets of operations given a CRDT and a test
  # block.
  def test_merge(crdt, opts = {}, &block)
    count = opts[:count] || COUNT
    forks = opts[:forks] || rand(5) + 1

    count.times do
      operations = forks.times.map { operations() }
      input, splits, merged = splurge crdt.clone, operations
      if yield [splits, merged]
      else
        puts "Failed!"
        puts "Input"
        pp input
        puts "Operations"
        pp operations
        puts "Siblings"
        pp splits
        puts "Merged"
        pp merged
        false.should.be.true
      end
    end
    true.should.be.true
  end
end
