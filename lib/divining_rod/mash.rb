module DiviningRod
  class Mash < Hash

    def initialize(hsh = {})
      self.replace(hsh || {})
    end

    def merge(opts = {})
      if self[:tags] || opts[:tags]
        tags = Array(self[:tags]) | Array(opts[:tags])
        opts[:tags] = tags
      end
      super(opts)
    end

  end
end