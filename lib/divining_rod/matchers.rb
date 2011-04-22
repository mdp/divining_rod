module DiviningRod
  class Matchers
    class << self

      def ua(pattern, opts = {})
        Definition.new(opts) { |request|
          if pattern.match(request.env['HTTP_USER_AGENT'])
            true
          end
        }
      end

      def subdomain(pattern, opts={})
        Definition.new(opts) { |request|
          if pattern.match(DiviningRod::Utilities.parse_subdomain(request)[0])
            true
          end
        }
      end

      def ua_prof(pattern, opts ={})
        Definition.new(opts) {|request|
          if pattern.match(request.env['HTTP_X_WAP_PROFILE'])
            true
          end
        }
      end

    end
  end
end
