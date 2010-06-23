require 'spec_helper'
require 'rack'
require 'rack/mock'
require 'rack_spec_helper'


describe Rack::DiviningRod do
  
  before :each do 
    DiviningRod::Mappings.define do |map|
      map.ua /iPhone/, :format => :webkit, :tags => [:iphone, :youtube, :geolocate] do |iphone|
        iphone.ua /iPad/, :tags => [:ipad]
      end
    end
  end

  it "should set the format env" do
    app = mock('RackApp')
    app.should_receive(:call).with(hash_including('divining_rod.format' => :webkit)).and_return(
                                                     [200, {}, "WebPage!"])
    request = Rack::MockRequest.new(Rack::DiviningRod.new(app)).get("/", {"HTTP_USER_AGENT" => 'iPhone iPad'})
  end
  
  it "should set the format param" do
    app = mock('RackApp')
    app.should_receive(:call) { |env|
      req = Rack::Request.new(env)
      req.params["format"].should eql(:webkit)
      [200, {}, "WebPage!"]
    }
    request = Rack::MockRequest.new(Rack::DiviningRod.new(app)).get("/", {"HTTP_USER_AGENT" => 'iPhone iPad'})
  end
  
  it "should set the profile object env" do
    app = mock('RackApp')
    profile = DiviningRod::Profile.new(Rack::Request.new({"HTTP_USER_AGENT" => 'iPhone iPad'}))
    app.should_receive(:call) { |env|
      env['divining_rod.profile'].tags.should eql profile.tags
      [200, {}, "WebPage!"]
    }
    request = Rack::MockRequest.new(Rack::DiviningRod.new(app)).get("/", {"HTTP_USER_AGENT" => 'iPhone iPad'})
  end
  
end


