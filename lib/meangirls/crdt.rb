class Meangirls::CRDT
  require 'meangirls/set'
  require 'meangirls/counter'

  # Merge a list of CRDTs by folding over merge.
  def self.merge(*os)
    [*os].inject do |o1, o2|
      o1.merge o2
    end
  end

  def to_json
    as_json.to_json
  end
end
