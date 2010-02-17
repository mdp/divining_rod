require 'yaml'

module DiviningRod
  
  class UndefinedDefault < StandardError
    
  end
  
  class Profile
    
    attr_reader :match
    
    def initialize(request)
      matchers.each do |matcher|
        @match = matcher if matcher.matches?(request)
        break if @match
      end
      raise UndefinedDefault, "Please define a default group for DiviningRod" unless @match
    end

    def group
      @match.group
    end
    alias_method :format, :group
    
    def method_missing(meth)
      if meth.to_s.match(/(.+)\?$/)
        tag = $1
        @match.tags.include?(tag.to_s) ||  @match.tags.include?(tag.to_sym) || @match.tags == tag
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
      
      def clear_definitions
        @definitions = []
      end
      
      def ua(pattern, group, opts={})
        @definitions ||= []
        @definitions << Definition.new(group, opts) { |request|
          if pattern.match(request.user_agent)
            true
          end
        }
      end
      
      def default(group, opts = {})
        @definitions ||= []
        @definitions << Definition.new(group, opts) { |request| true }
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