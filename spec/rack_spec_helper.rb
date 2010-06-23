def request(app, opts={})
  resp = Rack::MockResponse.new(200, {}, "foo")
  @request = Rack::MockRequest.new(app.new(resp)).get("/", opts)
end