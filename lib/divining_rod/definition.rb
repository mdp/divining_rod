module DiviningRod
  class Definition

    attr_accessor :prc, :group, :opts, :parent

    def initialize(opts={}, &blk)
      @prc = blk
      @opts = Mash.new(opts)
    end

    def evaluate(request)
      result = nil
      child_result = nil
      if @prc.call(request)
        result = self
        unless self.children.empty?
          self.children.each do |child|
            child_result = child.evaluate(request)
            break if child_result
          end
        end
      end
      child_result || result
    end

    def tags
      @tags ||= opts[:tags] || []
    end

    def children
      @children ||= []
    end

    def format
      opts[:format]
    end

  end
end
