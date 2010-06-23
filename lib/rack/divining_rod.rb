module Rack
  class DiviningRod
   
   def initialize(app)
     @app = app
   end
   
   def call(env)
     req = Rack::Request.new(env) # Always returns the same Rack request object
     profile = ::DiviningRod::Profile.new(req)
     if profile && profile.format
       env['divining_rod.format'] = profile.format
       req[:format] = profile.format
     end
     env['divining_rod.profile'] = profile
     @app.call(env)
   end
    
  end
end