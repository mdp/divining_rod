module DiviningRod
  class Rack

    def initialize(app)
      @app = app
    end

    def call(env)
      request = ::Rack::Request.new(env)
      profile = DiviningRod::Profile.new(request)
      env['divining_rod.profile'] = profile
      @app.call(env)
    end

  end
end
