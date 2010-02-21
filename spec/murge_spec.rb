require 'spec_helper'

describe DiviningRod::Murge do
  
  it "should merge two hashes" do
    old_hash = {:tags => :iphone}
    new_hash = {:tags => :ipad}
    DiviningRod::Murge.murge(old_hash, new_hash, :tags).should eql({:tags => [:iphone, :ipad]})
  end
end