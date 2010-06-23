require 'spec_helper'

describe DiviningRod::Mappings do

  before :each do
    DiviningRod::Mappings.define(:tags => :mobile) do |map|
      map.ua /Apple/, :format => :webkit, :tags => [:apple] do |apple|

        # iPod, iPhone, and iPad
        apple.with_options :tags => [:youtube, :geolocate, :iphone] do |advanced|
          advanced.ua /iPad/, :tags => :ipad do |ipad|
            ipad.ua /OS\s4/, :tags => :version4
            ipad.ua /OS\s3/, :tags => :version3 do |v3|
              v3.ua /Unicorns/, :tags => :omg_unicorns do |unicorns|
                unicorns.ua /eat kittens/, :tags => [:omg_they_eat_kittens]
              end
            end
            ipad.ua /OS\s2/, :tags => :version2
          end
          advanced.ua /iPod/, :tags => [:ipod, :ipod_touch]
        end

        # Also an apple but actualy a newton
        apple.ua /Newton/, :tags => [:apple] do |newton|
          newton.ua /OS 8/, :tags => :os8
        end
      end
    end
  end

  it "should match a top level user agent" do
    request = mock("rails_request", :user_agent => 'Apple Mobile Safari', :format => :html)
    result = DiviningRod::Mappings.root_definition.evaluate(request)
    result.should_not be_nil
    result.tags.should include(:apple)
    result.tags.should_not include(:ipad)
    result.tags.should include(:mobile)
  end

  it "should match a child definition" do
    ipad_request = mock("rails_request", :user_agent => 'Apple iPad', :format => :html)
    result = DiviningRod::Mappings.evaluate(ipad_request)
    result.tags.should include(:ipad)
  end

  it "should match a sub child definition" do
    ipad_request = mock("rails_request", :user_agent => 'Apple iPad - now powered by Unicorns - OS 3.3', :format => :html)
    result = DiviningRod::Mappings.evaluate(ipad_request)
    result.tags.should include(:ipad)
    result.tags.should include(:omg_unicorns)
    result.tags.should include(:version3)
  end

  it "should match a really really deep child definition" do
    ipad_request = mock("rails_request", :user_agent => 'Apple iPad - now powered by Unicorns who eat kittens - OS 3.3', :format => :html)
    result = DiviningRod::Mappings.evaluate(ipad_request)
    result.tags.should include(:ipad, :youtube)
    result.tags.should include(:omg_unicorns)
    result.tags.should include(:omg_they_eat_kittens)
    result.tags.should include(:version3)
  end

  it "should match a in order defined" do
    ipad_request = mock("rails_request", :user_agent => 'Apple iPad - now powered by Unicorns who eat kittens - OS 2', :format => :html)
    result = DiviningRod::Mappings.evaluate(ipad_request)
    result.tags.should include(:ipad, :youtube)
    result.tags.should_not include(:omg_they_eat_kittens, :omg_unicorns)
    result.tags.should include(:version2)
  end

  it "should match a in order defined" do
    ipad_request = mock("rails_request", :user_agent => 'Apple Newton - OS 8', :format => :html)
    result = DiviningRod::Mappings.evaluate(ipad_request)
    result.tags.should_not include(:omg_they_eat_kittens, :omg_unicorns)
    result.tags.should include(:os8)
  end
  
  
  # Each definition should have a hash associated with it, that allows us to
  # cookie the user with the hash, and quickly retrieve the definition
  # without reevaluating the request object.
  #
  # This should work in a git-ish way, letting parent definitions mutations
  # continue down the chain.
  # describe "finding a definition with a hash" do
  #   
  #   it "should return a definition" do
  #     ipad_request = mock("rails_request", :user_agent => 'Apple Newton - OS 8', :format => :html)
  #     result = DiviningRod::Mappings.evaluate(ipad_request)
  #     definition = DiviningRod::Mappings.find(result.hash)
  #     definition.should eql(result)
  #   end
  #   
  # end

end
