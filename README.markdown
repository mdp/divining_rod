# Divining Rod

A tool to help format your sites mobile pages.

## Installation

    gem install divining_rod
    
## Usage

_initializers/divining\_rod.rb_

    DiviningRod::Matchers.define do |map|
        # map.ua /user_agent_regex/, :format, :tags => []
        map.ua /iPhone/, :webkit, :tags => [:iphone, :youtube_capable]
        map.ua /Android/, :webkit, :tags => [:android, :youtube_capable, :google_gears]
        map.subdomain /wap/, :wap, :tags => [:crappy_old_phone]
        
        # Enable this to forces a default format if unmatched
        # otherwise it will return the request.format
        # map.default :html 
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

This is still very much in beta, but we are using it in production. As such we plan
to do our best to keep the API the same.

The user agent definitions will be updated here later this week.

## Todo

### Copyright

Copyright (c) 2010 Mark Percival. See LICENSE for details.
