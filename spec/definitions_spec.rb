require 'spec_helper'

describe DiviningRod::Definitions do
  
  before :each do 
    @request = mock("rails_request", :user_agent => 'My iPhone', :format => :html)
    DiviningRod::Definitions.clear_definitions
    DiviningRod::Definitions.define do |map|
      map.ua /iPhone/, :format => :webkit, :tags => [:iphone, :youtube, :geolocate] do |iphone|
        iphone.ua /iPad/, :tags => [:ipad] do |ipad|
          ipad.ua /Unicorns/, :tags => [:omg_unicorns]
        end
        iphone.ua /iPod/, :tags => [:ipod, :ipod_touch]
        iphone.ua /iPood/, :tags => [:poop]
      end
    end
  end
  
  it "should match a top level user agent" do
    result = DiviningRod::Definitions.evaluate(@request)
    result.should_not be_nil
    result.tags.should include(:iphone)
  end
  
  it "should match a child definition" do
    ipad_request = mock("rails_request", :user_agent => 'My iPhone is really an iPad', :format => :html)
    result = DiviningRod::Definitions.evaluate(ipad_request)
    result.tags.should include(:ipad)
  end
  
  it "should match a sub child definition" do
    ipad_request = mock("rails_request", :user_agent => 'New iPad - now with Unicorns', :format => :html)
    result = DiviningRod::Definitions.evaluate(ipad_request)
    result.tags.should include(:ipad)
    result.tags.should include(:omg_unicorns)
  end
  
end