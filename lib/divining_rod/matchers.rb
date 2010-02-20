module DiviningRod
  class Matchers
    # Matchers create and keep track of the definitions.

    class << self

      attr_accessor :definitions

      def define
        yield(self)
      end

      def ua(pattern, group = nil, opts={}, &blk)
        opts[:tags] = @parent_tags + opts[:tags].to_a if @parent_tags
        group ||= @parent_group
        add_definition Definition.new(group, opts) { |request|
          if pattern.match(request.user_agent)
            true
          end
        }
        if block_given?
          @parent_tags = opts[:tags]
          @parent_group = group
          yield(self)
        end
      end

      def subdomain(pattern, group, opts={})
        add_definition Definition.new(group, opts) { |request|
          if pattern.match(request.subdomains[0])
            true
          end
        }
      end

      def default(group, opts = {})
        add_definition Definition.new(group, opts) { |request| true }
      end

      def add_definition(definition)
        @definitions ||= []
        @definitions << definition
      end

      def clear_definitions
        @definitions = []
      end

    end

  end
end
