class Meangirls::CRDT
  require 'meangirls/set'

  # Merge a list of CRDTs by folding over merge.
  def self.merge(*os)
    [*os].inject do |o1, o2|
      o1.merge o2
    end
  end
end
