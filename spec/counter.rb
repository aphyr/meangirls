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
    a.should === 1

    b = @class.new.increment('foo', 2)
    b += 3
    b.should === 5
  end

  should '-' do
    a = @class.new
    (a - 0).should === a
    (a - 1).should === -1 rescue Meangirls::DecrementNotAllowed
  end

  should 'float?' do
    a = @class.new
    a.float?.should.be.false
    (a + 0.001).float?.should.be.true
  end

  should 'merge with self' do
    a = @class.new
    a.merge(a).should === a
  end

  should 'merge with self after increment' do
    a = @class.new
    a + 1
    a.merge(a).should === a
  end

  should 'merge independent increments' do
    a = @class.new
    b = @class.new
    a.increment('a', 1)
    b.increment('b', 1)
    a.merge(b).should === 2
  end

  should 'increment' do
    @s.increment('a', 1).should === 1
    @s.increment('a', 1).should === 2
  end

  should 'to_i' do
    @s.to_i.should === 0
    (@s + 0.001).to_i.should === 0
    (@s + 1).to_i.should === 1
  end

  should 'to_f' do
    @s.to_f.should === 0.0
    (@s + 0.001).to_f.should === 0.001
    (@s + 1).to_f.should === 1.001
  end
end
