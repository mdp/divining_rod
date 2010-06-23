require 'digest/sha1'

module DiviningRod
  class HashDump

    def self.serialize(hsh)
      serialized_strings = []
      hsh.each_pair do |k,v|
        if v.is_a? Hash
          serialized_strings << "#{k.inspect}=>#{serialize(v)}"
        elsif v.is_a? Array
          v.collect!{|a| a.inspect}
          serialized_strings << "#{k.inspect}=>[#{v.sort.join(',')}]"
        else
          serialized_strings << "#{k.inspect}=>#{v.inspect}"
        end
      end
      
      "{#{serialized_strings.sort.join(',')}}"
    end
    
    def self.sha(hsh)
      Digest::SHA1.hexdigest(serialize(hsh))
    end

  end
end
