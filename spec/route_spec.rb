require 'spec_helper'

describe DiviningRod::Route do
  
  before :each do
    @root_definition = DiviningRod::Definition.new { true }
    mapper = DiviningRod::Route.new(@root_definition, {:tags => [:fuck], :foo => true})
    mapper.ua /Safari/, :tags => [:baz] do |map|
      map.with_options :tags => :awsome do |awesome|
        awesome.ua /Apple/, :tags => [:foo]
      end
    end
  end
  
  it "should map a definition" do
    request = mock("rails_request", :user_agent => 'Apple Mobile Safari', :format => :html)
    result = @root_definition.evaluate(request)
    result.tags.should include(:fuck)
  end
  
end