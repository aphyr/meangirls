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
  behaves_like :prob

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

  should 'preserve latest writes' do
    crdt = @class.new
    test_merge crdt do |siblings, merged|
      # Reconstruct transaction log.
      log = []
      siblings.each do |s|
        s.e.each do |e, pair|
          if t = pair.add
            log << [t, :add, e]
          end
          if t = pair.remove
            log << [t, :remove, e]
          end
        end
      end
      log.sort_by!(&:first)

      # Todo: compact log, removing identical timestamps and choosing operation based on crdt.bias.
      # Not needed currently as local timestamps are guaranteed unique within process.

      # Replay log on top of original
      model = log.inject(crdt.to_set) do |set, op|
        case op[1]
        when :add
          set.add op.last
        when :remove
          set.delete op.last
        end
      end

      model == merged.to_set
    end
  end
end
