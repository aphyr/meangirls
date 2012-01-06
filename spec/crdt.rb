require 'yajl/json_gem'

shared :crdt do
  should 'as_json' do
    j = @s.as_json
    j.should.be.kind_of? Hash
    j['type'].should == @s.type
  end

  should 'round trip' do
    @examples.each do |t|
      Meangirls.parse(t.as_json).should == t
      Meangirls.parse(JSON.parse(t.as_json.to_json)).should == t
    end
  end
end
