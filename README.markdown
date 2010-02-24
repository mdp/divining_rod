# Divining Rod

A tool to help format your sites mobile pages.

## Installation

    gem install divining_rod

## Example
  
  Using the example configuration (found in [example_config.rb](http://github.com/markpercival/divining_rod/blob/master/example_config.rb)])
  
    # For a request with the user agent
    # "Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5H11 Safari/525.20"
    
    profile = DiviningRod::Profile.new(request)
    profile.iphone?           #=> true
    profile.name              #=> 'iPhone'
    profile.youtube_capable?  #=> true
    profile.format            #=> :webkit
    
    
## Usage

_initializers/divining\_rod.rb_

    DiviningRod::Mappings.define do |map|
        # Android based phones
        map.ua /Android/, :format => :webkit, :name => 'Android', :tags => [:android, :youtube_capable, :google_gears]

        # Apple iPhone OS
        map.ua /Apple.*Mobile.*Safari/, :format => :webkit, :tags => [:apple, :iphone_os, :youtube_capable] do |iphone|
          iphone.ua /iPad/, :tags => :ipad, :name => 'iPad'
          iphone.ua /iPod/, :tags => :ipod, :name => 'iPod Touch'
          iphone.ua /iPhone/, :tags => [:iphone], :name => 'iPhone'
        end

        #Blackberry, needs more detail here
        map.ua /BlackBerry/, :tags => :blackberry, :name => 'BlackBerry'
        map.subdomain /wap/, :format => :wap, :tags => [:crappy_old_phone]
        
        # Enable this to forces a default format if unmatched
        # otherwise it will return the request.format
        # map.default :format => :html 
    end

_initializers/mime\_types.rb_
    
    Mime::Type.register_alias "text/html", :webkit
    
_app/controllers/mobile\_controller.rb_

    class MobileController < ApplicationController
      before_filter :detect_mobile_type

      ....

      private

      def detect_mobile_type
        # If the profile isn't matched it defaults to request.format
        @profile = DiviningRod::Profile.new(request)
        request.format = @profile.format
      end

    end
    
_app/views/mobile/show.webkit.html_

    <%- if @profile.iphone? %>
      <%= link_to "Install our iPhone App in the AppStore", @iPhone_appstore_url %>
    <%- elsif @profile.android? %>
      <%= link_to "Direct download", @android_app_url %>
    <% end %>

    
## Note on the development

Tags always merge, while all other hash keys get overridden. Tags also will always allow you to call them as
booleans. Ex @profile.iphone? 

If the :format key isn't available we default to request.format.

## Todo

### Copyright

Copyright (c) 2010 Mark Percival. See LICENSE for details.
