shared :counter do
  should 'create a counter' do
    @class.new.should.be.kind_of? @class
  end

  should '==' do
    a = @class.new
    b = @class.new
    a.should == b

    a += 1
    a.should.not == b
    b += 2
    a.should.not == b
    a += 1
    a.should == b

    a.increment('foo', 2)
    a.should.not == b
    b.increment('foo', 2)
    a.should == b
  end

  should '===' do
    @s.should === @s
    @s.should === 0
    @s.should === 0.0
  end

  should '+' do
    a = @s + 1
    a.should.be.kind_of? Meangirls::Counter
    a.should == 1

    b = @class.new.increment('foo', 2)
    b += 3
    b.should === 5
  end

  should '-' do
  end

  should 'float?' do
    @class.new.increment(1)
  end

  should 'merge' do
  end

  should 'increment' do
  end

  should 'to_i' do
  end

  should 'to_f' do
  end
end
