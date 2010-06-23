module DiviningRod
  class Route
    include Utils
    
    def initialize(parent, default_opts = {})
      @parent = parent
      @default_opts = default_opts
    end

    def pattern(type, pattern, opts = {})
      opts = murge(default_options, opts)
      definition = Matchers.send(type.to_sym, pattern, opts)
      append_to_parent(definition)
      if block_given?
        yield self.class.new(definition)
      end
      definition
    end
    
    def with_options(opts)
      yield self.class.new(@parent, opts)
    end

    def default(opts = {})
      definition = Definition.new(opts) { true }
      append_to_parent(definition)
      definition
    end

    def method_missing(meth, *args, &blk)
      # Lets us use map.ua instead of map.pattern :ua
      if Matchers.respond_to?(meth.to_sym)
        self.pattern(meth, args[0], args[1,], &blk)
      else
        super
      end
    end

    private
    
      def default_options
        @default_opts || {}
      end

      def append_to_parent(definition)
        if @parent
          @parent.add_child(definition)
        end
        definition
      end

  end


end
