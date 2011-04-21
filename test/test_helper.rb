require 'rubygems'
require 'rack'
require 'test/unit'
require 'shoulda'
require 'mocha'
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'divining_rod'

include Mocha::API

def request_mock(opts)
  opts = {
           :host => 'example.com'
         }.merge(opts)
  env = {'HTTP_USER_AGENT' => opts[:ua], 'SERVER_NAME' => opts[:host], 'X_WAP_PROFILE' => opts[:wap_profile]}
  stub(:env => env, :format => opts[:format])
end
