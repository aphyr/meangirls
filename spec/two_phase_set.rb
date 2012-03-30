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

  should 'not add deleted elements' do
    @s << 1
    @s.delete 1
    lambda { @s << 1 }.should.raise Meangirls::ReinsertNotAllowed
  end

  should 'not delete nonexistent elements' do
    lambda { @s.delete 1 }.should.raise Meangirls::DeleteNotAllowed
  end
end
