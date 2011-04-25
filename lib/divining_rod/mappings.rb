module DiviningRod
  class Mappings

    class << self

      attr_accessor :root_definition

      def define(opts = {})
        @root_definition = Definition.new(opts) { true }
        yield Mappings.new(@root_definition)
        @root_definition
      end

      def evaluate(obj)
        @root_definition.evaluate(obj)
      end

    end

    attr_reader :default_opts, :parent

    def initialize(parent, default_opts = {})
      @parent = parent
      @default_opts = Mash.new(default_opts)
    end

    def pattern(type, pattern, opts = {})
      definition = Matchers.send(type.to_sym, pattern, merged_opts(opts))
      append_to_parent(definition)
      if block_given?
        yield self.class.new(definition)
      end
      definition
    end

    def default(opts = {})
      definition = Definition.new(merged_opts(opts)) { true }
      append_to_parent(definition)
      definition
    end

    def with_options(opts)
      yield self.class.new(parent, opts)
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

    def merged_opts(opts)
      opts = parent.opts.merge(opts)
      opts = default_opts.merge(opts)
      opts
    end

    def append_to_parent(definition)
      parent.children << definition
      definition
    end


  end
end
