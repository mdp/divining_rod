module DiviningRod
  class Definitions
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

      def ua(pattern, opts={}, &blk)
        if @parent #merge the settings if they have a parent definition
          tags = Array(opts[:tags]) | @parent.tags
          opts = @parent.opts.merge(opts)
          opts[:tags] = tags # tags are merged, not overridden
        end
        definition = Definition.new(opts) { |request|
          if pattern.match(request.user_agent)
            true
          end
        }
        add_definition(definition, @parent)
        if block_given?
          @parent = definition
          yield(self)
        end
        @parent = nil #reset the scope
      end

      def subdomain(pattern, opts={})
        add_definition Definition.new(opts) { |request|
          if pattern.match(request.subdomains[0])
            true
          end
        }
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

    end

  end
end
