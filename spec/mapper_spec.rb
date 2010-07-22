require 'spec_helper'

describe DiviningRod::Mapper do
  
  before :each do
    @root_definition = DiviningRod::Definition.new { true }
    mapper = DiviningRod::Mapper.new(@root_definition, {:tags => [:fuck], :foo => true})
    mapper.ua /Safari/, :tags => [:baz] do |map|
      map.with_options :tags => :awsome do |awesome|
        awesome.ua /Apple/, :tags => [:foo]
      end
    end
  end
  
  it "should map a definition" do
    request = request_mock(:ua => 'Apple Mobile Safari', :format => :html)
    result = @root_definition.evaluate(request)
    result.tags.should include(:fuck)
  end
  
end