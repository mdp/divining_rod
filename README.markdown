# Divining Rod
<img src='http://public.mpercival.com.s3.amazonaws.com/images/divining_rod.jpg' />

A tool to profile web requests. Especially useful for mobile site development

## Installation

    gem install divining_rod

## Example

  Using the example configuration (found in [example_config.rb](http://github.com/markpercival/divining_rod/blob/master/example_config.rb))

    # For a request with the user agent
    # "Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_2_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5H11 Safari/525.20"

    profile = DiviningRod::Profile.new(request)
    profile.iphone?           #=> true
    profile.name              #=> 'iPhone'
    profile.youtube_capable?  #=> true
    profile.format            #=> :webkit

## Mappings

Matches happen in the order they are defined, and then proceed down to the subsequent block. So for example:

    DiviningRod::Mappings.define do |map|
      map.ua /Apple/, :format => :webkit, :tags => [:apple, :iphone_os] do
        iphone.ua /iPad/, :tags => :ipad, :name => 'iPad', :format => nil
        iphone.ua /iPod/, :tags => :ipod, :name => 'iPod Touch'
        iphone.ua /iPhone/, :tags => :iphone, :name => 'iPhone'
      end
    end

Will match "Apple iPad" first with the /Apple/ matcher, then with the /iPad/ matcher, and the tags will be

    [:apple, :iphone_os, :ipad] # Notice tags get appended, *not* overridden.

And _:format_ will be set to _nil_

Why _nil_? Because when :format is set to _nil_ and you ask for it, DiviningRod will return the original _request_ objects format.

## Usage

_initializers/divining\_rod.rb_

    DiviningRod::Mappings.define do |map|
        # Android based phones
        map.ua /Android/, :format => :webkit, :name => 'Android', :tags => [:android, :youtube_capable, :google_gears]

        # Apple iPhone OS
        map.ua /Apple.*Mobile.*Safari/, :format => :webkit, :tags => [:apple, :iphone_os, :youtube_capable] do |iphone|
          iphone.ua /iPad/, :tags => :ipad, :name => 'iPad', :format => nil
          iphone.ua /iPod/, :tags => :ipod, :name => 'iPod Touch'
          iphone.ua /iPhone/, :tags => :iphone, :name => 'iPhone'
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

## Writing your own custom profiler

You can also include the DiviningRod::Profiler mixin in your own custom class

_lib/browser_profile.rb_

    class BrowserProfile
      include DivingingRod::Profiler

      def has_an_app_store?
        android? || iphone? || windows_phone?
      end

    end

Usage

    prof = BrowserProfile.new(request)
    prof.has_an_app_store?

## Todo

### Copyright

Copyright (c) 2010 Mark Percival. See LICENSE for details.
