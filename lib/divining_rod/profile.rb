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

    def tagged?(tag)
      if match
        Array(match.tags).include?(tag.to_sym)
      else
        false
      end
    end

    def method_missing(meth)
      if meth.to_s.match(/(.+)\?$/)
        tag = $1
        tagged?(tag)
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

