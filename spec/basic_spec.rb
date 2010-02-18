require 'spec_helper'

describe DiviningRod do

  before :each do
    @request = mock("rails_request", :user_agent => 'My iPhone')
    DiviningRod::Matchers.clear_definitions
    DiviningRod::Matchers.define do |map|
      map.ua /iPhone/, :webkit, :tags => [:iphone, :youtube, :geolocate]
    end
  end

  it "should recognize an iPhone" do
    profile = DiviningRod::Profile.new(@request)
    profile.format.should eql(:webkit)
  end

  it "should know if it belongs to a category tag" do
    profile = DiviningRod::Profile.new(@request)
    profile.geolocate?.should be_true
  end

  it "should know if it does not belongs to a category" do
    profile = DiviningRod::Profile.new(@request)
    profile.wap?.should be_false
  end
  
  describe "without a default route" do
    
    before :each do
      @request = mock("rails_request", :user_agent => 'My Foo Fone', :format => :html)
      DiviningRod::Matchers.clear_definitions
      DiviningRod::Matchers.define do |map|
        map.ua /iPhone/, :webkit, :tags => [:iphone, :youtube, :geolocate]
      end
    end

    it "should use the default group for unknown phones" do
      profile = DiviningRod::Profile.new(@request)
      profile.wap?.should be_false
      profile.format.should eql(:html)
    end

  end
  

  describe "with a default route" do
    
    before :each do
      @request = mock("rails_request", :user_agent => 'My Foo Fone')
      DiviningRod::Matchers.clear_definitions
      DiviningRod::Matchers.define do |map|
        map.ua /iPhone/, :webkit, :tags => [:iphone, :youtube, :geolocate]
        map.default :html
      end
    end

    it "should use the default group for unknown phones" do
      profile = DiviningRod::Profile.new(@request)
      profile.wap?.should be_false
      profile.format.should eql(:html)
    end

  end

  describe "without a default definition" do

    before :each do
      @request = mock("rails_request", :user_agent => 'Foo Fone')
      DiviningRod::Matchers.clear_definitions
      DiviningRod::Matchers.define do |map|
        map.ua /iPhone/, :webkit, :tags => [:iphone, :youtube, :geolocate]
      end
    end

    it "should not find a match" do
      DiviningRod::Profile.new(@request).recognized?.should be_false
    end

  end
  
  describe "matching a subdomain" do

    before :each do
      @request = mock("rails_request", :user_agent => 'Foo Fone', :subdomains => ['wap'])
      DiviningRod::Matchers.clear_definitions
      DiviningRod::Matchers.define do |map|
        map.subdomain /wap/, :wap, :tags => [:shitty]
      end
    end

    it "should not find a match" do
      DiviningRod::Profile.new(@request).recognized?.should be_true
      profile = DiviningRod::Profile.new(@request)
      profile.wap?
    end

  end
  
  describe "matching the weird requests(no user_agent passed)" do

    before :each do
      @request = mock("rails_request", :user_agent => nil, :subdomains => [])
      DiviningRod::Matchers.clear_definitions
      DiviningRod::Matchers.define do |map|
        map.ua /iPhone/, :wap, :tags => [:shitty]
      end
    end

    it "should not find a match" do
      DiviningRod::Profile.new(@request).recognized?.should be_false
    end

  end

end


describe DiviningRod::Matchers do

  before :each do
    @request = mock("rails_request", :user_agent => 'iPhone Foo')
    DiviningRod::Matchers.clear_definitions
    DiviningRod::Matchers.define do |map|
      map.ua /iPhone/, :iphone, :tags => [:iphone, :youtube]
    end
  end

  it "should recognize an iPhone" do
    DiviningRod::Matchers.definitions.first.matches?(@request).should be_true
    DiviningRod::Matchers.definitions.first.group.should eql(:iphone)
  end

  describe "defining a default definition" do

    before :each do
      @request = mock("rails_request", :user_agent => 'Foo Fone')
      DiviningRod::Matchers.clear_definitions
      DiviningRod::Matchers.define do |map|
        map.default :unknown, :tags => [:html]
      end
    end

    it "should use the default route if no other match is found" do
      DiviningRod::Matchers.definitions.first.matches?(@request).should be_true
      DiviningRod::Matchers.definitions.first.group.should eql(:unknown)
    end

  end

end
