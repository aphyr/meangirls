shared :set do
  should 'create an empty set' do
    n = @s
    n.should.be.empty
  end

  should '==' do
    @s.should == @s
    a = @class.new
    b = @class.new
    a.should == b
    a << 1
    a.should.not == b
    b << 1
    a.should == b
    a.delete 1
    a.should.not == b
    b.delete 1
    a.should == b
  end

  should '===' do
    @s.should === @s
    @s.should === []
    @s.should === Set.new
  
    a = @class.new
    a << 1
    a << 2
    a.should === [2,1]
    a.should === [1,2].to_set
    a.should === (1..2)

    a.delete 1
    a.should === [2]
    a.should === [2].to_set
    a.should === (2..2)
  end

  should '&' do
    (@s & []).should === []
    (@s & [1,2,3]).should === []

    a = @class.new
    a << 1
    a << 2
    (a & []).should === []
    (a & [1,3]).should === [1]
  end

  should '|' do
    (@s | []).should === []
    (@s | [1,2,3]).should === [1,2,3]

    a = @class.new
    a << 1
    a << 2
    (a | []).should == a
    (a | []).should === [1,2]
    (a | [2,3]).should == (a << 3)
    (a | [2,3]).should === [1,2,3]
  end

  should '-' do
    (@s - []).should == @s
    (@s - [1,2,3]).should === [] rescue Meangirls::DeleteNotAllowed

    a = @class.new
    a << 1
    a << 2
    (a - []).should == a
    (a - [2]).should === [1]
    (a - [2,3]).should === [1] rescue Meangirls::DeleteNotAllowed
  end

  should '<<' do
    (@s << 1).should === [1]
    (@s << 1 << 2).should === [1,2]
  end

  should 'delete' do
    @s.delete(1).should == nil rescue Meangirls::DeleteNotAllowed
    @s.should === []

    a = @class.new
    a << 1
    a << 2
    a.delete(1).should == 1
    a.should === [2]
  end

  should 'empty' do
    @s.should.be.empty
    @s << 1
    @s.should.not.be.empty
    @s.delete 1
    @s.should.be.empty
  end

  should 'merge empty sets' do
    # Empty set
    @s.merge(@s).should == @s
  end

  should 'merge with self' do
    a = @class.new
    a << 1
    a << 2
    a.merge(a).should == a
  end

  should 'merge disjoint sets' do
    a = @class.new
    a << 2

    b = @class.new
    b << 1
    b << 3
    a.merge(b).should === [1,2,3]
    b.merge(a).should == a.merge(b)
  end

  should 'merge overlapping sets' do
    a = @class.new
    a << 1
    a << 2
    b = @class.new
    b << 2
    b << 3
    a.merge(b).should === [1,2,3]
    b.merge(a).should == a.merge(b)
  end

  ([@s.bias] | (@class.biases rescue [])).each do |bias|
    should "merge biased towards #{bias}" do
      case bias
      when 'a'
        # Should preserve adds
        a = @class.new
        a << 1
        a.delete 1
        b = @class.new
        b << 1
        a.merge(b).should === [1]
        b.merge(a).should == a.merge(b)
      when 'r'
        # Should preserve deletes
        a = @class.new
        a << 1
        a.delete 1
        b = @class.new
        b << 1
        a.merge(b).should === []
        b.merge(a).should == a.merge(b)
      end
    end
  end

  should 'size' do
    @s.size.should == 0
    @s << 1
    @s.size.should == 1
    @s << 1
    @s.size.should == 1
    @s.delete 1
    @s.size.should == 0
  end
end
