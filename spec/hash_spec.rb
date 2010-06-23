require 'spec_helper'

describe DiviningRod::HashDump do
  
  it "should serialize a hash" do
    hash = {:format => 'iPhone', :tags => [:webkit, :apple, :html5], :version => '4'}
    serialized_hash = DiviningRod::HashDump.serialize(hash)
    serialized_hash.should eql('{:format=>"iPhone",:tags=>[:apple,:html5,:webkit],:version=>"4"}')
  end
  
  it "should serialize a complex hash" do
    hash = {:format => {:xml=>"what",:json=>:foo}, :tags => [:webkit, :apple, :html5], :version => '4'}
    serialized_hash = DiviningRod::HashDump.serialize(hash)
    serialized_hash.should eql('{:format=>{:json=>:foo,:xml=>"what"},:tags=>[:apple,:html5,:webkit],:version=>"4"}')
  end
  
  it "should serialize and sha a hash" do
    hash = {:format => {:json=>:foo,:xml=>"what"}, :tags => [:webkit, :apple, :html5], :version => '4'}
    sha = DiviningRod::HashDump.sha(hash)
    sha.should eql("c167c9f2913687b8f23f3908684d5f358cacb1b5")
  end
  
end