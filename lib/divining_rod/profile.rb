module DiviningRod
  module Profiler

    def initialize(request)
      @request = request
    end

    def match
      @match ||= DiviningRod::Mappings.evaluate(@request)
    end

    def format
      if match && match.format
        match.format
      else
        @request.format
      end
    end

    def recognized?
      match != DiviningRod::Mappings.root_definition
    end

    def method_missing(meth)
      if meth.to_s.match(/(.+)\?$/)
        tag = $1
        if match
          match.tags.include?(tag.to_s) ||  match.tags.include?(tag.to_sym) || match.tags == tag
        else
          false
        end
      elsif match.opts.include?(meth.to_sym)
        match.opts[meth]
      else
        super
      end
    end

  end

  class Profile
    include Profiler
  end
end

