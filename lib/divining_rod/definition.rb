module DiviningRod
  class Definition
    include Murge

    attr_accessor :prc, :group, :opts, :parent
    attr_writer :children

    def initialize(opts={}, &blk)
      @prc = blk
      @opts = opts
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
      opts[:tags] || []
    end
    
    def opts
      if parent
        @murged_opts ||= murge(parent.opts, @opts)
      else
        @opts
      end
    end
    
    def format
      opts[:format]
    end
    
    def children
      @children ||= []
      @children.each do |child|
        child.parent ||= self
      end
      @children
    end

  end
end
