require 'spec_helper'
require "divining_rod/rack"
require "rack/test"

describe DiviningRod do
  include Rack::Test::Methods

  def app
    DiviningRod::Rack.new(app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['foo']] })
  end

  before :each do
    DiviningRod::Mappings.define do |map|
      map.ua /iPhone/, :format => :webkit, :tags => [:iphone, :youtube, :geolocate] do |iphone|
        iphone.ua /iPad/, :tags => [:ipad]
      end
    end
  end

  it "should profile an incoming request" do
    header 'User-Agent', "iPhone Safari"
    get "/"
    last_request.mobile_profile.should be_an_instance_of(DiviningRod::Profile)
    last_request.mobile_profile.iphone?.should be_true
  end

end