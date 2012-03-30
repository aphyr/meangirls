describe 'lww-set' do
  before do
    @class = Meangirls::LWWSet
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

  should '==' do
    a = @class.new
    b = @class.new
    a.add 1, 0
    b.add 1, 0
    a.should == b

    a.delete 1, 1
    a.should.not == b
    b.delete 1, 1
    a.should == b
  end
end
