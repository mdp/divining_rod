require 'test_helper'

class DefinitionTest < Test::Unit::TestCase
  context DiviningRod::Definition do

    should "work with no children not match" do
      definition = DiviningRod::Definition.new(:format => :iphone, :tags => [:overpriced, :easy_to_break]) { |request|
        request == 'iphone'
      }
      assert_equal definition.evaluate('foo'), nil
    end

    should "work with no children and match" do
      definition = DiviningRod::Definition.new(:format => :iphone, :tags => [:overpriced, :easy_to_break]) { |request|
        request == 'iphone'
      }
      assert_equal definition, definition.evaluate('iphone')
    end

    context "with children" do

      should "work with children that match" do
        definition = DiviningRod::Definition.new(:format => :iphone, :tags => [:overpriced, :easy_to_break]) { |request|
          request.match(/iphone/)
        }
        definition.children << DiviningRod::Definition.new(:format => :ipod, :tags => [:small, :lacks_a_camera]) { |request|
          request.match(/ipod/)
        }
        definition.children << DiviningRod::Definition.new(:format => :ipad, :tags => [:big, :lacks_a_camera]) { |request|
          request.match(/ipad/)
        }
        result = definition.evaluate('iphone ipad')
        assert_equal :ipad, result.format
        assert result.tags.include?(:big)
      end


    end

  end
end
