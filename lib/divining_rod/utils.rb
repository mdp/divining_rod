module DiviningRod
  module Utils
    require 'digest/sha1'
    
    # This is tacky, but I'm preserving tags in the option hash
    # and only want to have to write this once
    #
    def murge(old_opts, new_opts)
      old_opts = old_opts || {}
      tags = Array(old_opts[:tags]) | Array(new_opts[:tags])
      opts = old_opts.merge(new_opts)
      opts[:tags] = tags
      opts
    end
    
    def sort_and_concat(obj, parent_hash = nil)
      values = []
      if obj.is_a? Hash
        d = obj.keys.sort { |a,b| a.inspect <=> b.inspect }
        d.each do |name| 
          val = obj[name]
          values << '%s:%s:%s' % [val.class, name, sort_and_concat(val)]
        end
      elsif obj.is_a? Array
        d = obj.sort { |a,b| a.inspect <=> b.inspect }
        d.each do |val| 
          values << '%s:%s' % [val.class, sort_and_concat(val)]
        end
      else
        values << '%s:%s' % [obj.class, obj.to_s]
      end
      values.join(',')
    end
    
    def hash_a_hash(obj, parent_hash = '')
      Digest::SHA1.hexdigest(sort_and_concat(obj) + parent_hash)
    end
    
  end
end