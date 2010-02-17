# Divining Rod

A tool to help format your sites mobile pages.

## Installation

    gem install divining_rod
    
## Usage

_initializers/divining\_rod.rb_

    DiviningRod::Matchers.define do |map|
        map.ua /iPhone/, :webkit, :tags => [:iphone, :youtube_capable]
        map.ua /Android/, :webkit, :tags => [:android, :youtube_capable, :google_gears]
        
        # Coming soon
        # map.subdomain /wap/, :wap, :tags => [:crappy_old_phone]
        map.default :html
    end

_initializers/mime\_types.rb_
    
    Mime::Type.register_alias "text/html", :webkit
    
_app/controllers/mobile\_controller.rb_

    class MobileController < ApplicationController
      before_filter :detect_mobile_type

      ....

      private

      def detect_mobile_type
        @profile = DiviningRod::Profile.new(request)
        if @profile.recognized?
          request.format = @profile.format
        end
      end

    end
    
_app/views/mobile/show.webkit.html_

    <%- if @profile.iphone? %>
      <%= link_to "Install our iPhone App in the AppStore", @iPhone_appstore_url %>
    <%- elsif @profile.android? %>
      <%= link_to "Direct download", @android_app_url %>
    <% end %>

    
## Note on the development

This is still very much in beta, but we are using it extensively in production. As such we plan
to do our best to keep the API the same.

The user agent definitions will be updated here later this week.

### Todo

* Add a subdomain router

### Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

### Copyright

Copyright (c) 2010 Mark Percival. See LICENSE for details.
