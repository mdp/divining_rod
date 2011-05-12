require 'test_helper'

DiviningRod::Mappings.define(:format => :html, :tags => [:foo]) do |map|
    map.ua /First/, :name => 'First', :tags => [:first]
    map.ua /SecondMatch/, :name => 'Second', :tags => [:second]
    map.with_options :tags => :grouping1 do |with_options|
      with_options.ua /ThirdMatch/, :name => "ThirdMatch", :tags => [:third_match]
      with_options.ua /FourthMatch/, :name => "FourthMatch", :tags => [:fourth_match]
    end
    map.ua /FifthMatch/, :name => 'FifthMatch', :tags => [:fifth_match, :and_more]
    map.ua /ThirdMatch/, :name => "Failure", :tags => [:failed] # Shouldn't get here

    map.ua /Stuffed Crust/, :name => 'Stuffed Crust', :tags => [:woo_hoo] do |sc|
      sc.ua /Vegan/, :name => 'Bleh'
      sc.with_options :name => "Meat and Cheese" do |mac|
        mac.ua /With Bacon/, :tags => :bacon
        mac.ua /With Ham/, :tags => :round_bacon
        mac.ua /With Tofu/, :tags => :tofu, :name => "NotMeat and Cheese"
      end
    end

    map.with_options :tags => :second_group do |second_group|
      second_group.ua /ThirdMatch/
      second_group.ua /SixthMatch/
    end

    map.ua /Last/, :tags => :last

    map.default :name => "Unknown", :tags => :unknown
end

def profile_ua(ua)
  DiviningRod::Profile.new(request_mock(:ua => ua))
end

class ExampleConfigTest < Test::Unit::TestCase
  context 'the example config' do

    context "with root definition options" do
      should "carry through" do
        profile = profile_ua("Unknown phone")
        assert_equal "Unknown", profile.name
        assert_equal :html, profile.format
      end
    end

    context "after a with_options block" do
      should "not affect subsequest matches" do
        profile = profile_ua("Last")
        assert_equal [:foo, :last], profile.tags
      end
    end

    context "matching a sub options group" do
      should "overide the parent" do
        profile = profile_ua("Stuffed Crust With Tofu")
        assert_equal "NotMeat and Cheese", profile.name
        profile = profile_ua("Stuffed Crust With Bacon")
        assert_equal "Meat and Cheese", profile.name
      end
    end

    should "match with tags" do
      profile = profile_ua("FifthMatch")
      assert_equal "FifthMatch", profile.name
      assert profile.and_more?
    end

    should "stop at the first match" do
      profile = profile_ua("ThirdMatch")
      assert profile.third_match?
      assert profile.grouping1?
      assert !profile.failed?
    end


  end
end
