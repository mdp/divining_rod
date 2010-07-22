require 'rubygems'
require 'spec'
require 'rack'
require  File.expand_path('../../lib/divining_rod', __FILE__)

def request_mock(opts)
  opts = {
           :host => 'example.com'
         }.merge(opts)
  env = {'HTTP_USER_AGENT' => opts[:ua], 'SERVER_NAME' => opts[:host], 'X_WAP_PROFILE' => opts[:wap_profile]}
  mock('RailsRequest', :env => env, :format => opts[:format])
end