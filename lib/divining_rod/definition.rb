module DiviningRod
  class Definition

    attr_accessor :prc, :group
    attr_writer :tags

    def initialize(group, opts={}, &blk)
      @group = group
      @prc = blk
      @tags = opts[:tags]
    end

    def matches?(request)
      !!@prc.call(request)
    end

    def tags
      @tags ||= []
    end

  end
end
