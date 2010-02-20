module DiviningRod
  class Profile

    attr_reader :match

    def initialize(request)
      @request = request.clone #Lets not mess with the real one
      definitions.each do |definition|
        @match = definition if definition.matches?(request)
        break if @match
      end
      nil
    end

    def group
      if @match
        @match.group
      else
        @request.format
      end
    end
    alias_method :format, :group

    def recognized?
      !!@match
    end

    def method_missing(meth)
      if meth.to_s.match(/(.+)\?$/)
        tag = $1
        if @match
          @match.tags.include?(tag.to_s) ||  @match.tags.include?(tag.to_sym) || @match.tags == tag
        else
          false
        end
      else
        super
      end
    end

    def definitions
      DiviningRod::Matchers.definitions || []
    end

  end
end
