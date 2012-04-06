describe 'or-set' do
  before do
    @class = Meangirls::ORSet
    @idempotent = false
    @s = @class.new
    @examples = [
      @class.new,
      (@class.new << 1),
      (@class.new - [1,2]),
      (@class.new - [1,2] + [2,3]),
      (@class.new + [1,2] - [2,3])
    ]
  end

  behaves_like :crdt
  behaves_like :set
  behaves_like :prob

  should '==' do
    a = @class.new
    b = @class.new
    a.add 1, 0
    b.add 1, 0
    a.should == b

    a.delete 1
    a.should.not == b
    b.delete 1
    a.should == b
  end

  should 'preserve independent adds' do
    test_merge @class.new do |sibs, merged|
      sibs.inject(Set.new) do |present, sib|
        present | sib.to_set
      end.all? do |e|
        merged.include? e
      end
    end
  end
end
