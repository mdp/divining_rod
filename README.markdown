# Divining Rod

A tool to help format your sites mobile pages.

## Installation

    gem install divining_rod
    
## Usage

_initializers/divining\_rod.rb_

    DiviningRod::Mapping.define do |map|
        # map.ua /user_agent_regex/, :format => :wml, :tags => [:your_tag]
        map.ua /Apple.*Mobile.*Safari/, :format => :webkit, :tags => [:apple, :youtube_capable] do |iphone|
          iphone.ua /iPhone/, :tags => :iphone
          iphone.ua /iPad/, :tags => :ipad do |ipad|
            ipad.ua /Unicorns/, :tags => [:omg_unicorns, :magic], :format => :happiness
          end
          iphone.ua /iPod/, :tags => :ipod
        map.ua /Android/, :format => :webkit, :tags => [:android, :youtube_capable, :google_gears]
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

Any of keys can be used and queried arbitrarily.

## Todo

### Copyright

Copyright (c) 2010 Mark Percival. See LICENSE for details.
