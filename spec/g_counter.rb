describe 'g-counter' do
  before do
    @class = Meangirls::GCounter
    @s = @class.new
    @examples = [
      @class.new,
      @class.new.increment('a', 1),
      @class.new.increment('a', 1).increment('b', 0).increment('c', 1500.125)
    ]
  end

  behaves_like :crdt
  behaves_like :counter
end
