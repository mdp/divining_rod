module DiviningRod
  class Definition

    attr_accessor :prc, :group, :opts
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
            if child.evaluate(request)
              child_result = child
            end
            break if child_result
          end
        end
      end
      child_result || result
    end

    def tags
      @opts[:tags] ||= []
    end
    
    def format
      @opts[:format]
    end
    
    def children
      @children ||= []
    end

  end
end
