require 'yaml'

module DiviningRod

  class Profile

    attr_reader :match

    def initialize(request)
      @request = request.clone #Lets not mess with the real one
      matchers.each do |matcher|
        @match = matcher if matcher.matches?(request)
        break if @match
      end
      nil
    end

    def group
      if @match
        @match.group
      else
        @request.format
      end
    end
    alias_method :format, :group

    def recognized?
      !!@match
    end

    def method_missing(meth)
      if meth.to_s.match(/(.+)\?$/)
        tag = $1
        if @match
          @match.tags.include?(tag.to_s) ||  @match.tags.include?(tag.to_sym) || @match.tags == tag
        else
          false
        end
      else
        super
      end
    end

    def matchers
      DiviningRod::Matchers.definitions || []
    end

  end

  class Matchers

    class << self

      attr_accessor :definitions

      def define
        yield(self)
      end

      def ua(pattern, group, opts={})
        add_definition Definition.new(group, opts) { |request|
          if pattern.match(request.user_agent)
            true
          end
        }
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

  class Definition

    attr_accessor :prc, :tags, :group

    def initialize(group, opts={}, &blk)
      @group = group
      @tags = opts[:tags] || []
      @prc = blk
    end

    def matches?(request)
      !!@prc.call(request)
    end

  end

end
