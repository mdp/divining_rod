module DiviningRod
  module Murge
    
    # This is tacky, but I'm preserving tags in the option hash
    # and only want to have to right this once
    #
    def murge(old_opts, new_opts)
      old_opts = old_opts || {}
      tags = Array(old_opts[:tags]) | Array(new_opts[:tags])
      opts = old_opts.merge(new_opts)
      opts[:tags] = tags
      opts
    end
    
  end
end