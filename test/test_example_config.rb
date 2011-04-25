require 'test_helper'
require 'example_config'

def profile_ua(ua)
  DiviningRod::Profile.new(request_mock(:ua => ua))
end


class ExampleConfigTest < Test::Unit::TestCase
  context 'the example config' do

    context "recognizing Apple devices" do

      should "recognize an iPad" do
        profile = profile_ua("Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10")
        assert profile.ipad?
      end

      should "recognize an iPod touch 2.2.1" do
        profile = profile_ua("Mozilla/5.0 (iPod; U; CPU iPhone OS 2_2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5H11 Safari/525.20")
        assert profile.ipod?
      end

      should "recognize an iPod touch 3.1.2" do
        profile = profile_ua("Mozilla/5.0 (iPod; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7D11 Safari/528.16")
        assert profile.ipod?
      end

      should "recognize an iPhone 3.1.2" do
        profile = profile_ua("Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7D11 Safari/528.16")
        assert profile.iphone?
      end

      should "recognize an iPhone 2.1.2" do
        profile = profile_ua("Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5H11 Safari/525.20")
        assert profile.iphone?
      end

    end

    context "recognizing Android devices" do

      should "recognize a basic android" do
        profile = profile_ua("Mozilla/5.0 (Linux; U; Android 1.0; en-us; dream) AppleWebKit/525.10+ (KHTML, like Gecko) Version/3.0.4 Mobile Safari/523.12.2")
        assert profile.android?
      end

    end

    context "recognizing desktop browsers" do

      should "recognize Internet Explorer 10" do
        profile = profile_ua("Mozilla/4.0 (compatible; MSIE 10.0; Windows NT 7.0)")
        assert profile.desktop?
        assert_equal profile.version, 10
        assert profile.html5?
      end

    end

    context "with root definition options" do
      should "carry through" do
        profile = profile_ua("Unknown phone")
        assert_equal "Unknown", profile.name
        assert_equal :html, profile.format
      end
    end


  end
end
