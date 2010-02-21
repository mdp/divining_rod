module DiviningRod
  class Matchers
    class << self
      
      def ua(pattern, opts = {})
        Definition.new(opts) { |request|
          if pattern.match(request.user_agent)
            true
          end
        }
      end
      
      def subdomain(pattern, opts={})
        Definition.new(opts) { |request|
          if pattern.match(request.subdomains[0])
            true
          end
        }
      end
      
    end
  end
end
