module DiviningRod
  class Profile

    attr_reader :match

    def initialize(request)
      @request = request.clone #Lets not mess with the real one
      @match = DiviningRod::Mappings.evaluate(request)
    end

    def format
      if @match && @match.format
        @match.format
      else
        @request.params[:format]
      end
    end

    def recognized?
      @match != DiviningRod::Mappings.root_definition
    end

    def method_missing(meth)
      if meth.to_s.match(/(.+)\?$/)
        tag = $1
        if @match
          @match.tags.include?(tag.to_s) ||  @match.tags.include?(tag.to_sym) || @match.tags == tag
        else
          false
        end
      elsif @match.opts.include?(meth.to_sym)
        @match.opts[meth]
      else
        super
      end
    end

  end
end
