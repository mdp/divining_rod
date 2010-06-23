module DiviningRod
  class Mappings

    class << self

      attr_accessor :root_definition, :route_indices
      
      def define(opts = {})
        @root_definition = Definition.new { true }
        yield Route.new(@root_definition, opts)
      end
      
      def evaluate(obj)
        @root_definition.evaluate(obj)
      end
      
    end

  end
end
