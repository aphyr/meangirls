describe '2p-set' do
  before do
    @class = Meangirls::TwoPhaseSet
    @s = @class.new
    @examples = [
      @class.new,
      (@class.new << 1),
      (@class.new + [1,2] - [2])
    ]
  end

  behaves_like :crdt
  behaves_like :set
  behaves_like :prob

  should 'not add deleted elements' do
    @s << 1
    @s.delete 1
    lambda { @s << 1 }.should.raise Meangirls::ReinsertNotAllowed
  end

  should 'not delete nonexistent elements' do
    lambda { @s.delete 1 }.should.raise Meangirls::DeleteNotAllowed
  end

  should 'include all non-deleted added elements' do
    test_merge(@s) do |siblings, merged|
      adds = Set.new
      removes = Set.new
      siblings.each do |s|
        adds += s.a
        removes += s.r
      end
      merged.to_set.should == (adds - removes)       
    end
  end
end
