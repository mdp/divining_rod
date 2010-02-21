require 'spec_helper'

describe DiviningRod::Mapping do
  
  before :each do 
    DiviningRod::Mapping.clear_definitions
    DiviningRod::Mapping.define do |map|
      map.ua /Apple/, :format => :webkit, :tags => [:iphone, :youtube, :geolocate] do |iphone|
        iphone.ua /iPad/, :tags => :ipad do |ipad|
          ipad.ua /OS\s4/, :tags => :version4
          ipad.ua /OS\s3/, :tags => :version3 do |v3|
            v3.ua /Unicorns/, :tags => :omg_unicorns do |unicorns|
              unicorns.ua /eat kittens/, :tags => [:omg_they_eat_kittens]
            end
          end
          ipad.ua /OS\s2/, :tags => :version2
        end
        iphone.ua /iPod/, :tags => [:ipod, :ipod_touch]
      end
      map.ua /Newton/, :tags => [:apple, :newton] do |newton|
        newton.ua /OS 8/, :tags => :os8
      end
    end
  end
  
  it "should match a top level user agent" do
    request = mock("rails_request", :user_agent => 'Apple Mobile Safari', :format => :html)
    result = DiviningRod::Mapping.evaluate(request)
    result.should_not be_nil
    result.tags.should include(:iphone)
    result.tags.should_not include(:ipad)
  end
  
  it "should match a child definition" do
    ipad_request = mock("rails_request", :user_agent => 'Apple iPad', :format => :html)
    result = DiviningRod::Mapping.evaluate(ipad_request)
    result.tags.should include(:ipad)
  end
  
  it "should match a sub child definition" do
    ipad_request = mock("rails_request", :user_agent => 'Apple iPad - now powered by Unicorns - OS 3.3', :format => :html)
    result = DiviningRod::Mapping.evaluate(ipad_request)
    result.tags.should include(:ipad)
    result.tags.should include(:omg_unicorns)
    result.tags.should include(:version3)
  end
  
  it "should match a really really deep child definition" do
    ipad_request = mock("rails_request", :user_agent => 'Apple iPad - now powered by Unicorns who eat kittens - OS 3.3', :format => :html)
    result = DiviningRod::Mapping.evaluate(ipad_request)
    result.tags.should include(:ipad, :youtube)
    result.tags.should include(:omg_unicorns)
    result.tags.should include(:omg_they_eat_kittens)
    result.tags.should include(:version3)
  end
  
  it "should match a in order defined" do
    ipad_request = mock("rails_request", :user_agent => 'Apple iPad - now powered by Unicorns who eat kittens - OS 2', :format => :html)
    result = DiviningRod::Mapping.evaluate(ipad_request)
    result.tags.should include(:ipad, :youtube)
    result.tags.should_not include(:omg_they_eat_kittens, :omg_unicorns)
    result.tags.should include(:version2)
  end
  
  it "should match a in order defined" do
    ipad_request = mock("rails_request", :user_agent => 'Newton - OS 8', :format => :html)
    result = DiviningRod::Mapping.evaluate(ipad_request)
    result.tags.should_not include(:omg_they_eat_kittens, :omg_unicorns)
    result.tags.should include(:os8)
  end
  
end