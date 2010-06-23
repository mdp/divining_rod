require 'spec_helper'

describe DiviningRod::Definition do
  
  it "should work with no match" do
    definition = DiviningRod::Definition.new(:format => :iphone, :tags => [:overpriced, :easy_to_break]) { |request|
      request == 'iphone'
    }
    definition.evaluate('foo').should be_nil
  end
  
  it "should match a definition and return it" do
    definition = DiviningRod::Definition.new(:format => :iphone, :tags => [:overpriced, :easy_to_break]) { |request|
      request == 'iphone'
    }
    definition.evaluate('iphone').should eql(definition)
  end
  
  describe "with children" do
    
    before :each do
      @definition = DiviningRod::Definition.new(:format => :iphone, :tags => [:overpriced, :easy_to_break]) { |request|
        request.match(/iphone/)
      }
      @definition.add_child  DiviningRod::Definition.new(:format => :ipod, :tags => [:small, :lacks_a_camera]) { |request|
        request.match(/ipod/)
      }
      @definition.add_child DiviningRod::Definition.new(:format => :ipad, :tags => [:big, :lacks_a_camera]) { |request|
        request.match(/ipad/)
      }
      @definition.children.first.add_child DiviningRod::Definition.new(:format => :ipad, :tags => [:big, :lacks_a_camera]) { |request|
        request.match(/newton/)
        }
    end
    
    it "should work with children that match" do
      result = @definition.evaluate('iphone ipad')
      result.should_not eql(@definition)
      result.format.should eql(:ipad)
      result.tags.should include(:overpriced)
    end
    
    it "should be able to get a flat list of descendants" do
      @definition.descendants.size.should eql 3
    end
    
    it "should be hashable" do
      p @definition.children.first.hash
      @definition.opts[:format] = :ipad
      p @definition.children.first.hash
    end
    
  end
  
end