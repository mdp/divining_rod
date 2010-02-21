module DiviningRod
  class Mapping
    # Matchers create and keep track of the definitions.

    class << self

      attr_accessor :definitions
      
      def define
        yield(self)
      end
      
      def evaluate(request)
        match = nil
        definitions.each do |definition|
          break if match = definition.evaluate(request)
        end
        match
      end
      
      # The only really complicated part of this whole endeavor
      # Matchers defines a definition method which is passed a regex pattern
      # and options, and returns the defintion object.
      # In this method we wrap the process to merge parent params and
      # add the defintion as a child of another defintion.
      #
      # Ex. map.pattern :ua, /iPhone/, :tags => [:apple, :webkit], :format => :webkit
      def pattern(type, pattern, opts = {})
        opts = self.merge_parent(opts)
        definition = Matchers.send(type.to_sym, pattern, opts)
        add_definition(definition, @parent)
        # And here's the recursive to let up define children of a definition
        if block_given?
          @parent = definition
          yield(self)
        end
        @parent = nil #reset the scope
      end

      def default(opts = {})
        add_definition Definition.new(opts) { |request| true }
      end

      def add_definition(definition, parent = nil)
        @definitions ||= []
        if parent && @definitions.index(parent)
          @definitions[@definitions.index(parent)].children << definition
        else
          @definitions << definition
        end
      end

      def clear_definitions
        @definitions = []
      end
      
      def method_missing(meth, *args, &blk)
        # Lets us use map.ua instead of map.pattern :ua
        if Matchers.respond_to?(meth.to_sym)
          self.pattern(meth, args[0], args[1,], &blk) 
        else
          super
        end
      end
      
      protected
      
      def merge_parent(opts)
        if @parent #merge the settings if they have a parent definition
          tags = Array(opts[:tags]) | @parent.tags
          opts = @parent.opts.merge(opts)
          opts[:tags] = tags # tags are merged, not overridden
        end
        opts
      end

    end

  end
end
