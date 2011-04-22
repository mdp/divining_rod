module DiviningRod
  class Utilities

    def self.parse_subdomain(request)
      env = request.env
      if forwarded = env["HTTP_X_FORWARDED_HOST"]
        host = forwarded.split(/,\s?/).last
      else
        host = env['HTTP_HOST'] || env['SERVER_NAME'] || env['SERVER_ADDR']
      end
      if host
        host.sub(/\:\d+/, '').split('.')
      else
        []
      end
    end

  end
end
