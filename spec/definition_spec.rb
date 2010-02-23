require 'spec_helper'

describe DiviningRod::Definition do
  
  it "should work with no children not match" do
    definition = DiviningRod::Definition.new(:format => :iphone, :tags => [:overpriced, :easy_to_break]) { |request|
      request == 'iphone'
    }
    definition.evaluate('foo').should be_nil
  end
  
  it "should work with no children and match" do
    definition = DiviningRod::Definition.new(:format => :iphone, :tags => [:overpriced, :easy_to_break]) { |request|
      request == 'iphone'
    }
    definition.evaluate('iphone').should eql(definition)
  end
  
  describe "with children" do
    
    it "should work with children that match" do
      definition = DiviningRod::Definition.new(:format => :iphone, :tags => [:overpriced, :easy_to_break]) { |request|
        request.match(/iphone/)
      }
      definition.children << DiviningRod::Definition.new(:format => :ipod, :tags => [:big, :lacks_a_camera]) { |request|
        request.match(/ipod/)
      }
      definition.children << DiviningRod::Definition.new(:format => :ipad, :tags => [:big, :lacks_a_camera]) { |request|
        request.match(/ipad/)
      }
      result = definition.evaluate('iphone ipad')
      result.should_not eql(definition)
      result.format.should eql(:ipad)
      result.tags.should include(:overpriced)
    end
    
    
  end
  
end