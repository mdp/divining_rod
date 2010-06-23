module DiviningRod
  class Definition
    include Utils
    
    attr_accessor :prc, :opts, :parent

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
    end
    
    def hash
      if @parent
        hash_a_hash(opts, @parent.hash)
      else
        hash_a_hash(opts)
      end
    end
    
    # Returns a list of all descendents
    #
    def descendants
      desc = children.collect { |child| child.descendants}
      [children, desc].flatten
    end
    
    def add_child(child)
      children << child
      child.parent = self
    end

  end
end
