require 'spec/spec_helper'
require 'example_config'


def request_mock(ua, subdomain = [])
  mock('RailsRequest', :user_agent => ua, :subdomain => subdomain)
end

def profile_ua(ua)
  DiviningRod::Profile.new(request_mock(ua))
end
  

describe 'the example config' do

  describe "recognizing Apple devices" do

    it "should recognize an iPad" do
      profile = profile_ua("Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10")
      profile.ipad?.should be_true
    end
    
    it "should recognize an iPod touch 2.2.1" do
      profile = profile_ua("Mozilla/5.0 (iPod; U; CPU iPhone OS 2_2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5H11 Safari/525.20")
      profile.ipod?.should be_true
    end
    
    it "should recognize an iPod touch 3.1.2" do
      profile = profile_ua("Mozilla/5.0 (iPod; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7D11 Safari/528.16")
      profile.ipod?.should be_true
    end
    
    it "should recognize an iPhone 3.1.2" do
      profile = profile_ua("Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7D11 Safari/528.16")
      profile.iphone?.should be_true
    end
    
    it "should recognize an iPhone 2.1.2" do
      profile = profile_ua("Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5H11 Safari/525.20")
      profile.iphone?.should be_true
    end
    
  end
  
  describe "recognizing Android devices" do
    
    it "should recognize a basic android" do
      profile = profile_ua("Mozilla/5.0 (Linux; U; Android 1.0; en-us; dream) AppleWebKit/525.10+ (KHTML, like Gecko) Version/3.0.4 Mobile Safari/523.12.2")
      profile.android?.should be_true
    end
    
  end
  
  describe "recognizing desktop browsers" do
    
    it "should recognize Internet Explorer 7" do
      profile = profile_ua("Mozilla/4.0 (compatible; MSIE 7.0b; Windows NT 6.0)")
      profile.desktop?.should be_true
      profile.version.should eql(7)
    end
    
  end


end
