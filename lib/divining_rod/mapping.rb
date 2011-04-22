module DiviningRod
  class Mapping

    class << self

      attr_accessor :root_definition

      def define(opts = {})
        @root_definition = Definition.new { true }
        yield Mapping.new(@root_definition, opts)
        @root_definition
      end

      def evaluate(obj)
        @root_definition.evaluate(obj)
      end

    end

    attr_reader :default_opts

    def initialize(parent, default_opts = {})
      @parent = parent
      @default_opts = Mash.new(default_opts)
    end

    def pattern(type, pattern, opts = {})
      @opts = Mash.new(opts)
      definition = Matchers.send(type.to_sym, pattern, merged_opts)
      append_to_parent(definition)
      if block_given?
        yield self.class.new(definition)
      end
      definition
    end

    def with_options(opts)
      @opts = Mash.new(opts)
      yield self.class.new(@parent, merged_opts)
    end

    def merged_opts
      opts = @parent.opts.merge(@opts) if @parent
      opts = default_opts.merge(opts)
      opts
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

      def append_to_parent(definition)
        if @parent
          @parent.children << definition
        end
        definition
      end


  end
end
