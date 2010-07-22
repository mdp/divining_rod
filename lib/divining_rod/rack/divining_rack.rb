module DiviningRod
  class Rack

    def initialize(app)
      @app = app
    end

    def call(env)
      request = ::Rack::Request.new(env)
      profile = DiviningRod::Profile.new(request)
      env['mobile_profile'] = profile
      @app.call(env)
    end

  end
end


::Rack::Request.send :define_method, :mobile_profile do
  env['mobile_profile']
end